# Be sure to restart your server when you modify this file.

# =============================================================================
# SECURITY UPDATE (2026): the Content Security Policy is now ON (it used to be
# fully commented out).
#
# A CSP tells the browser "only run scripts and load styles from THIS site."
# So even if someone managed to slip <script>alert('hacked')</script> into an
# article or comment, the browser would refuse to run it. To make this possible,
# the app no longer uses any inline JavaScript (the old rails-ujs "Destroy" link
# was replaced - see app/assets/javascripts/application.js).
#
# Think of it as the Schnee Dust Company's vault door: only approved Dust gets in.
# =============================================================================

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src     :self
    policy.font_src        :self, :data
    policy.img_src         :self, :data
    policy.object_src      :none
    policy.script_src      :self
    policy.style_src       :self
    policy.base_uri        :self
    policy.form_action     :self
    # Nobody can put this site inside an <iframe> to trick people into clicking things.
    policy.frame_ancestors :none
  end

  # Rails' own development tools (like the web-console on error pages) add small
  # inline scripts. A random "nonce" per request lets ONLY those approved scripts
  # run, while anything injected by an attacker still gets blocked.
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
end
