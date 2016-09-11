require 'alchemyapi'

class ArticlesController < ApplicationController
  def index
    articles = HTTParty.get('https://public-api.wordpress.com/wp/v2/sites/techcrunch.com/posts')
    @subjects = []
    @actions = []
    @objects = []
    @key_terms = {}
    first_title = articles[0]['title']['rendered']
    @format_first_title = HTMLEntities.new.decode(first_title)

    articles.each_with_index do |article, index|
        title = article['title']['rendered']
        coder = HTMLEntities.new
        alchemyapi = AlchemyAPI.new()
        format_title = coder.decode(title)
        response = alchemyapi.relations("text", format_title)

        for relation in response['relations']
            if relation.key?('subject')
              subject = relation['subject']['text']
              @key_terms["subject"] = subject if index == 0
              @subjects << subject
            end

            if relation.key?('action')
              action = relation['action']['text']
              @key_terms["action"] = action if index == 0
              @actions << action
            end

            if relation.key?('object')
              object = relation['object']['text']
              @key_terms["object"] = object if index == 0
              @objects << object
            end
          end
    end
      @new_title = @format_first_title.gsub(@key_terms["subject"], @subjects.sample)
      @new_title.gsub!(@key_terms["action"], @actions.sample)
      @new_title.gsub!(@key_terms["object"], @objects.sample)

      # @format_first_title.gsub!(@key_terms["subject"], @subjects.sample)
      # @format_first_title.gsub!(@key_terms["action"], @actions.sample)
      # @format_first_title.gsub!(@key_terms["object"], @objects.sample)

  end
end
    # articles.each do |article|
    #   title = article['title']['rendered']
    #   coder = HTMLEntities.new
    #   alchemyapi = AlchemyAPI.new()
    #   format_title = coder.decode(title)
    #   response = alchemyapi.relations("text", format_title)
    #
    #   for relation in response['relations']
    #     if relation.key?('subject')
    #       @subjects << relation['subject']['text']
    #     end
    #
    #     if relation.key?('action')
    #       @actions << relation['action']['text']
    #       # puts 'action: ' + relation['action']['text']
    #     end
    #
    #     if relation.key?('object')
    #       @objects << relation['object']['text']
    #       # puts 'object: ' + relation['object']['text']
    #     end
    #   end
