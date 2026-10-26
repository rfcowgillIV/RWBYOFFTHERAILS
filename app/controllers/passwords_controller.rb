# The Vault: a fun page that tells local visitors the demo editor login.
# It's an "index" action, so it's readable without logging in (otherwise nobody
# could read the hint telling them how to log in - a real chicken-and-Grimm problem).
#
# 2026 update: the view only shows the RWBY / DUST login when running locally
# with the default credentials. In production it never reveals anything
# (see ApplicationController#editor_login_hint).
class PasswordsController < ApplicationController
  def index
  end
end
