require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test "editor can add a comment" do
    assert_difference("@article.comments.count", 1) do
      post article_comments_url(@article),
           params: { comment: { commenter: "Yang", body: "That's what I call a Yang-tastic article!" } },
           headers: editor_headers
    end
    assert_redirected_to article_url(@article)
  end

  test "blank comments are rejected with a message" do
    assert_no_difference("Comment.count") do
      post article_comments_url(@article),
           params: { comment: { commenter: "", body: "" } },
           headers: editor_headers
    end
    assert_redirected_to article_url(@article)
    assert_match "Comment not posted", flash[:alert]
  end

  test "commenting requires the editor login" do
    assert_no_difference("Comment.count") do
      post article_comments_url(@article), params: { comment: { commenter: "Grimm", body: "rawr" } }
    end
    assert_response :unauthorized
  end
end
