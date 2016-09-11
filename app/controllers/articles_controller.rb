class ArticlesController < ApplicationController
  def index
    @articles = HTTParty.get('https://public-api.wordpress.com/wp/v2/sites/techcrunch.com/posts')
  end
end
