require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "needs a title of at least 5 characters" do
    assert_not Article.new(title: "Hey").valid?
    assert Article.new(title: "Hello Remnant").valid?
  end

  test "rejects giant articles" do
    assert_not Article.new(title: "Long one", text: "a" * 20_001).valid?
  end
end
