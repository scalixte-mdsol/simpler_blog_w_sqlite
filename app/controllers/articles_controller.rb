class ArticlesController < ApplicationController
  def show
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def index
    @article = Article.find(params[:id])
    flash[:notice] = 'View article by ' + @article.author
  end

  def update
    @article = Article.find(params[:id])
    flash[:notice] = 'Update article by ' + @article.author
  end

  def create_article
    @article = Article.create!(article_params)

    if @article.save
      flash[:notice] = "New article created."
      redirect_to articles_path
    else
      raise 'No new articles were added!!! :-('
    end
  end

  private

  def article_params
    params.require(:article).permit(:author, :title, :content)
  end
end
