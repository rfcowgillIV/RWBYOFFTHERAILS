require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "needs a commenter and a body" do
    comment = articles(:one).comments.build
    assert_not comment.valid?
    assert_includes comment.errors.attribute_names, :commenter
    assert_includes comment.errors.attribute_names, :body
  end

  test "a filled-in comment is valid" do
    assert articles(:one).comments.build(commenter: "Blake", body: "Reading is fun.").valid?
  end
end
