class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)

    # BUG FIX (2026): the old code used `.create` and redirected no matter what,
    # so a failed comment vanished without telling anyone. Now the visitor gets
    # a message saying what went wrong.
    if @comment.save
      redirect_to article_path(@article), notice: "Comment posted."
    else
      redirect_to article_path(@article), alert: "Comment not posted: #{@comment.errors.full_messages.to_sentence}."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
