require 'alchemyapi'

class ArticlesController < ApplicationController
  def index
    @articles = HTTParty.get('https://public-api.wordpress.com/wp/v2/sites/techcrunch.com/posts')
    @article = @articles[0]['title']['rendered']
    alchemyapi = AlchemyAPI.new()
    myText = @article
    response = alchemyapi.relations("text", myText)
    for relation in response['relations']
      if relation.key?('subject')
        puts 'subject: ' + relation['subject']['text']
      end

      if relation.key?('action')
        puts 'action: ' + relation['action']['text']
      end

      if relation.key?('object')
        puts 'object: ' + relation['object']['text']
      end
      puts ''
    end
  end
end
