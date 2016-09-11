require 'alchemyapi'

class ArticlesController < ApplicationController
  def index
    articles = HTTParty.get('https://public-api.wordpress.com/wp/v2/sites/techcrunch.com/posts')
    @subjects = []
    @actions = []
    @objects = []
    @locations = []
    #will store subject, action and object of first title
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

        if relation.key?('location')
          location = relation['location']['text']
          @key_terms["location"] = location if index == 0 && location
          @locations << location
        end
      end
    end

    #swaps the subject of original title with random subject from all articles
    @new_title = @format_first_title.gsub(@key_terms["subject"], @subjects.sample)
    #swaps the action of original title with random action from all articles
    @new_title.gsub!(@key_terms["action"], @actions.sample)
    #swaps the object of original title with random object from all articles
    @new_title.gsub!(@key_terms["object"], @objects.sample)
    #swaps the location of original title with random location from all articles
    @new_title.gsub!(@key_terms["location"], @locations.sample) if @key_terms["location"]

  end
end
