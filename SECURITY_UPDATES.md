# Security & Bug-Fix Update — October 2026

Everything changed in the `security-updates-2026` branch, why, and how to check it.
If something misbehaves later, start here.

> **TL;DR:** The app ran on Rails 5.2.2 and Ruby 2.6, both end-of-life with dozens of known
> security holes. It's now on **Rails 8.1** with a supported Ruby. The editor password is no
> longer hard-coded in the code or printed on a public page. A Content Security Policy is on,
> several bugs are fixed, and there are real tests.

---

## 1. The big one: Rails 5.2.2 → Rails 8.1 (the likely source of GitHub's alerts)

Rails 5.2 stopped receiving security fixes in 2022. The old `Gemfile.lock` pinned versions with
published vulnerabilities, including:

| Gem (old version) | Example problems |
|---|---|
| `rails` / `actionpack` / `actionview` 5.2.2 | Remote code execution, XSS, denial-of-service, file disclosure (e.g. CVE-2019-5418 "file content disclosure", CVE-2019-5419, CVE-2020-8164, CVE-2020-8165, CVE-2022-32224) |
| `rack` 2.0.6 | Multiple denial-of-service and header-parsing bugs (e.g. CVE-2020-8184, CVE-2022-30123, CVE-2023-27530) |
| `nokogiri` 1.10.1 | Multiple XML parsing vulnerabilities in bundled libxml2 |
| `loofah` 2.2.3 | XSS sanitizer bypasses (CVE-2019-15587, CVE-2022-23514/23515/23516) |
| `puma` 3.12.0 | HTTP request smuggling (CVE-2020-11076, CVE-2021-41136, CVE-2022-24790) |

### What changed in the Gemfile

| Removed | Replaced by / reason |
|---|---|
| `sass-rails`, `uglifier`, `coffee-rails` | **Propshaft**, the Rails 8 asset pipeline. The `.scss` files only contained plain CSS, so they were renamed to `.css`, with `//` comments converted to `/* */`. The `.coffee` files were empty. |
| `turbolinks` | Unmaintained, and nothing depended on it |
| `jbuilder` | The app never served JSON |
| `spring`, `spring-watcher-listen`, `listen` | Dropped from Rails defaults |
| `byebug` | Ruby's built-in `debug` gem |
| `chromedriver-helper` | Deprecated. `selenium-webdriver` now manages drivers itself. |

Added: `propshaft`, `brakeman` (Rails security scanner), and `bundler-audit` (checks gems against
the vulnerability database).

**`Gemfile.lock` was deleted on purpose**, since it pinned the vulnerable versions. The build
environment for this update couldn't reach RubyGems, so `bundle install` (see §7) creates the new
lock file. Commit it afterward.

### Config files rewritten for Rails 8

- `config/application.rb`: `load_defaults 8.1` (was 5.2). Loads only the Rails parts the app
  uses; Action Cable, Active Storage, Action Mailbox, and Action Text were never used.
- `config/environments/*.rb`, `config/puma.rb`, `config/boot.rb`, `bin/rails`, `bin/rake`,
  `bin/setup`: current Rails 8 versions.
- `db/schema.rb`: versioned schema header (`ActiveRecord::Schema[5.2]`). No tables changed and no
  new migrations, so existing data is untouched.
- Removed obsolete files: `config/spring.rb`, `config/cable.yml`, `config/storage.yml`,
  `app/channels/`, `app/assets/config/manifest.js`, `bin/update`, `bin/yarn`, `bin/bundle`,
  `package.json`, and 5.2-era initializers whose settings are now defaults.
- `.ruby-version`: 3.3.6 (Ruby 2.6 has been end-of-life since 2022).

## 2. Hard-coded login, published on the internet

**Before:** `ApplicationController` contained

```ruby
http_basic_authenticate_with name: "RWBY", password: "DUST", except: [:index, :show]
```

The repo is public, and the Vault page printed the login, so anyone could create, edit, or delete
articles.

**Now:**

- The editor login comes from environment variables: `BLOG_EDITOR_NAME` and `BLOG_EDITOR_PASSWORD`.
- **Development/test:** if those aren't set, RWBY / DUST still works, and the Vault page still
  shows it. The joke survives on your laptop.
- **Production:** no fallback. Without the variables, every write returns `403 Forbidden`, so the
  site is read-only instead of wide open. The Vault page says "The vault is sealed."
- Credentials are compared with `secure_compare`, which takes the same time whether a guess is
  close or not, so the password can't be guessed by timing.
- Production now forces HTTPS (`config.force_ssl = true`). HTTP Basic sends the password with every
  request, so it must never travel over plain HTTP.

```bash
export BLOG_EDITOR_NAME="Ruby"
export BLOG_EDITOR_PASSWORD="pick-a-long-random-phrase"
export SECRET_KEY_BASE="$(bin/rails secret)"   # needed in production
```

## 3. Content Security Policy turned on

`config/initializers/content_security_policy.rb` was fully commented out. It now tells browsers
to run scripts and load styles **only from this site**, block plugins, and refuse to be put in an
`<iframe>` (stops clickjacking). Even if someone slipped `<script>` into an article, the browser
wouldn't run it.

To make that possible, the app uses no inline JavaScript:

- The **Destroy** link was `link_to … method: :delete`, which needed rails-ujs (gone in Rails 7+).
  Without it, clicking "Destroy" would have just opened the article. It's now a `button_to` form
  (a real DELETE request with a CSRF token), and the "Are you sure?" pop-up comes from
  `app/assets/javascripts/application.js`.

## 4. Other hardening

- **Size limits:** article titles 5–200 characters, article text up to 20,000; commenter up to
  100, comment body up to 5,000. Comments can't be blank anymore.
- **Routes trimmed:** `resources :comments` → `only: :create`, and `resources :passwords` →
  `only: :index`. The old routes advertised URLs with no code behind them.
- **Log filtering** expanded to Rails' standard list (passwords, tokens, secrets, etc.).
- Added a `/up` health-check route for hosting providers.

## 5. Bugs fixed

| Bug | Fix |
|---|---|
| `app/models/comment.rb` contained a stray copy of the `CreateComments` **migration class**, loaded every time the app booted | Removed (the real migration is in `db/migrate/`) |
| Deleting an article left its comments orphaned | `has_many :comments, dependent: :destroy` |
| A failed comment silently disappeared | Shows "Comment not posted: …" |
| Invalid article forms wouldn't show errors under Rails 7+ | `render … status: :unprocessable_entity` |
| Each page put its own `<body>` tag inside the layout's `<body>`, and the header sat outside `<body>` | Layout uses `<body class="<%= content_for(:body_class) %>">`; pages set their class |
| Welcome page: `<h2>` "closed" with another `<h2>` turned the rest of the page into a heading | Fixed (Vault page too) |
| Edit page's "Edit" link pointed to itself | Now "Show" |
| Articles list "Preview" printed the entire article | Truncated to 120 characters |
| `comments.scss` pointed at `BLACKEC.png` (typo), so the image never loaded | `BLAKEC.png` |
| "Fan Aritcles" | "Fan Articles" |

## 6. Tests

The old test files were empty placeholders. There are now 22 tests covering:

- public pages load (home, Vault, article list, article page)
- writing without logging in, or with the wrong password, is rejected (401)
- the editor can create, update, and destroy articles; destroying removes comments
- blank comments are rejected with a message
- HTML in an article title is escaped, not run
- the Content-Security-Policy header is sent
- model validations

## 7. How to run and verify

```bash
# Ruby 3.2+ required (3.3.6 recommended, see .ruby-version)
bundle install                        # creates a new Gemfile.lock with patched versions
bin/rails db:prepare
bin/rails test                        # all tests should pass
bin/brakeman                          # Rails security scan, should report 0 warnings
bundle exec bundle-audit check --update   # should report no vulnerabilities
bin/rails server                      # then open http://localhost:3000
```

Manual checks:

1. Home page shows the RWBY background; the Vault page shows the demo login (locally).
2. "New article" asks for a login; RWBY / DUST works locally.
3. Create, edit, and destroy an article. Destroy asks "Are you sure?" first.
4. The browser's developer console shows no Content-Security-Policy errors.

## 8. Known limitations of this update

- The build environment had no access to RubyGems, so `bundle install` and `bin/rails test` could
  not be run before committing. Every Ruby, ERB, and YAML file passed a syntax check, but treat the
  first `bundle install` + `bin/rails test` run as the real verification. If anything fails, the
  error message plus this file should point to the change involved.
- `config/credentials.yml.enc` was left in place. Its decryption key (`config/master.key`) was
  never committed, so it can't be read. In production, set `SECRET_KEY_BASE` instead (see §2).

## Ongoing protection (added later in October 2026)

- **Password-guessing protection:** `ApplicationController` now uses Rails 8's built-in
  `rate_limit`. Each IP address gets 10 requests per minute to pages that need the editor
  login. After that, it gets `429 Too Many Requests` until the minute is up. Wrong-password
  attempts count too, so bots can't try thousands of passwords. (In tests, the cache is
  switched off, so the limit never triggers there. To see it work, run the server and hit
  "New article" 11 times in a minute.)
- **`SECURITY.md`** tells people how to report a security problem privately instead of in a public issue. For the "Report a vulnerability" button to appear, turn on **Settings → Code security → Private vulnerability reporting**.
- **CodeQL code scanning** (`.github/workflows/codeql.yml`): GitHub's free scanner checks the code for security bugs on every push and pull request to `master`, and weekly. Results appear under **Security → Code scanning**. Dependabot also keeps the workflow's own tools updated.
