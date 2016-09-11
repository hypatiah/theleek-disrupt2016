require 'alchemyapi'

class ArticlesController < ApplicationController
  def index
    articles = HTTParty.get('https://public-api.wordpress.com/wp/v2/sites/techcrunch.com/posts')
    article = articles[0]['title']['rendered']
    coder = HTMLEntities.new
    alchemyapi = AlchemyAPI.new()
    @article = coder.decode(article)
    response = alchemyapi.relations("text", @article)
    for relation in response['relations']
      if relation.key?('subject')
        @subject = relation['subject']['text']
        puts 'subject: ' + relation['subject']['text']
      end

      if relation.key?('action')
        @action = relation['action']['text']
        puts 'action: ' + relation['action']['text']
      end

      if relation.key?('object')
        @object = relation['object']['text']
        puts 'object: ' + relation['object']['text']
      end
    end

  end
end
