class ArticlesController < ApplicationController
  # 2026 update: the repeated `Article.find(params[:id])` lines were moved into
  # one before_action. DRY like a desert in Vacuo.
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.order(created_at: :desc)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article published. Dust off your hands!"
    else
      # Rails 7+ needs a 422 status here so browsers show the form errors.
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    # 303 See Other makes the browser follow up with a normal GET.
    redirect_to articles_path, notice: "Article destroyed. Lazers successful.", status: :see_other
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  # Strong parameters: only title and text can be set from a form. (Unchanged -
  # this part was already done right!)
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
