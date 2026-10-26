require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # 2026 update: headless Chrome (no window pops up). chromedriver-helper was
  # removed - selenium-webdriver now downloads the right driver automatically.
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
end
