// app/assets/javascripts/application.js
//
// 2026 update: this used to be a Sprockets manifest that pulled in rails-ujs,
// activestorage and turbolinks. Rails 8 doesn't use Sprockets, so it's now a
// plain JavaScript file that Propshaft serves as-is.
//
// Its one job: show the "Are you sure?" box before destroying an article.
// rails-ujs used to do that for `link_to ..., method: :delete, data: { confirm: }`.
// The Destroy link is now a real form button (button_to), which works even with
// JavaScript turned off, and this listener adds the confirmation on top.
//
// Because it lives in a file (not an inline onclick=""), the Content Security
// Policy can block all inline scripts. Safety first - Grimm consequences otherwise.

document.addEventListener("submit", function (event) {
  var form = event.target;
  var message = form && form.getAttribute("data-confirm");
  if (message && !window.confirm(message)) {
    event.preventDefault();
  }
});
