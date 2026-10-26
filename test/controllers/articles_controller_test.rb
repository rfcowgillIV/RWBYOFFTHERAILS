require "test_helper"

# 2026 update: these replace the empty placeholder tests. They check that reading
# is public, writing needs the editor login, and the main pages work on Rails 8.
class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test "anyone can read the article list" do
    get articles_url
    assert_response :success
    assert_select "td", text: @article.title
  end

  test "anyone can read a single article" do
    get article_url(@article)
    assert_response :success
    assert_select "h2", text: "Comments"
  end

  test "new article page requires the editor login" do
    get new_article_url
    assert_response :unauthorized
  end

  test "a wrong password is rejected" do
    get new_article_url, headers: editor_headers(password: "NOT-DUST")
    assert_response :unauthorized
  end

  test "editor can open the new article page" do
    get new_article_url, headers: editor_headers
    assert_response :success
  end

  test "editor can create an article" do
    assert_difference("Article.count", 1) do
      post articles_url, params: { article: { title: "Beacon Academy Tour", text: "Huge." } }, headers: editor_headers
    end
    assert_redirected_to article_url(Article.order(:created_at).last)
  end

  test "creating without logging in does nothing" do
    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "Sneaky Grimm Post", text: "Hi" } }
    end
    assert_response :unauthorized
  end

  test "invalid article re-renders the form with a 422" do
    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "Hi", text: "Too short a title" } }, headers: editor_headers
    end
    assert_response :unprocessable_entity
  end

  test "editor can update an article" do
    patch article_url(@article), params: { article: { title: "Crescent Rose, Revisited" } }, headers: editor_headers
    assert_redirected_to article_url(@article)
    assert_equal "Crescent Rose, Revisited", @article.reload.title
  end

  test "destroying an article also removes its comments" do
    assert_difference([ "Article.count", "Comment.count" ], -1) do
      delete article_url(@article), headers: editor_headers
    end
    assert_redirected_to articles_url
  end

  test "html in an article is shown as text, not run" do
    @article.update!(title: "<script>alert(1)</script> title")
    get articles_url
    assert_no_match "<script>alert(1)</script>", response.body
  end
end
