class ApplicationController < ActionController::Base
  # ===========================================================================
  # SECURITY UPDATE (2026): no more hard-coded username/password.
  #
  # BEFORE:  http_basic_authenticate_with name: "RWBY", password: "DUST"
  #   The login was typed right into the code, committed to a PUBLIC GitHub
  #   repo, AND printed on the public "Vault" page - so anyone could post,
  #   edit, or delete articles.
  #
  # NOW: the editor login comes from two environment variables:
  #   BLOG_EDITOR_NAME       e.g. export BLOG_EDITOR_NAME="Ruby"
  #   BLOG_EDITOR_PASSWORD   e.g. export BLOG_EDITOR_PASSWORD="a-long-secret-phrase"
  #
  #   - In development and test, if those aren't set, the classic RWBY / DUST
  #     login still works so the Vault page joke keeps working on your laptop.
  #   - In production there is NO fallback. If the variables aren't set, nobody
  #     can create/edit/delete - the site is read-only instead of wide open.
  #
  # The check uses secure_compare, which takes the same amount of time whether
  # the guess is close or not, so passwords can't be guessed by timing replies.
  # (TODO from 2019 "Later add a config file that would hide this from public
  # view" - consider it DUSTed.)
  # ===========================================================================
  DEV_EDITOR_NAME     = "RWBY".freeze
  DEV_EDITOR_PASSWORD = "DUST".freeze

  # Everyone can read (index/show pages); only editors can write.
  # Uses `unless:` instead of `except: [:index, :show]` because Rails 7.1+ raises an
  # error when `except:` names an action a controller doesn't have (e.g. comments
  # has no index or show), and this filter is shared by every controller.
  READ_ONLY_ACTIONS = %w[index show].freeze

  # SECURITY UPDATE (2026): password-guessing protection.
  # Each visitor (by IP address) gets 10 tries per minute at any page that needs
  # the editor login. A real editor never notices; a bot trying thousands of
  # passwords gets "429 Too Many Requests" and has to wait. This line must come
  # BEFORE require_editor so wrong-password attempts are counted too.
  # (Uses Rails 8's built-in rate_limit, which stores counts in Rails.cache.)
  # Slow down there, Grimm - no brute-forcing the Vault.
  rate_limit to: 10, within: 1.minute,
             unless: -> { READ_ONLY_ACTIONS.include?(action_name) },
             with: -> { head :too_many_requests }

  before_action :require_editor, unless: -> { READ_ONLY_ACTIONS.include?(action_name) }

  helper_method :editor_login_hint

  private

  def editor_name
    ENV["BLOG_EDITOR_NAME"].presence || (Rails.env.local? ? DEV_EDITOR_NAME : nil)
  end

  def editor_password
    ENV["BLOG_EDITOR_PASSWORD"].presence || (Rails.env.local? ? DEV_EDITOR_PASSWORD : nil)
  end

  def require_editor
    # Production with no credentials configured: lock writes entirely.
    if editor_name.blank? || editor_password.blank?
      return head :forbidden
    end

    authenticate_or_request_with_http_basic("RWBY Off The Rails editors") do |name, password|
      # Use "&" (not "&&") so BOTH comparisons always run - same timing either way.
      ActiveSupport::SecurityUtils.secure_compare(name, editor_name) &
        ActiveSupport::SecurityUtils.secure_compare(password, editor_password)
    end
  end

  # The Vault page only reveals the demo login when it's actually the login
  # (i.e. running locally with no custom credentials).
  def editor_login_hint
    using_defaults = ENV["BLOG_EDITOR_NAME"].blank? && ENV["BLOG_EDITOR_PASSWORD"].blank?
    return nil unless Rails.env.local? && using_defaults

    { name: DEV_EDITOR_NAME, password: DEV_EDITOR_PASSWORD }
  end
end
