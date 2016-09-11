require 'alchemyapi'


class WelcomeController < ApplicationController
	def index
		alchemyapi = AlchemyAPI.new()
		myText = "Apple released iPhone 7 today!"
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
