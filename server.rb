require 'sinatra'
require 'twitter'
require 'yaml'
require 'haml'
require 'gabbler'

get '/' do
	# show some generic stuff, documentation about mark, last tweet, etc
	@tweet = generate_tweet
  haml :index
end

def generate_tweet
	tweet = false
	until tweet
  	candidate = MARK.sentence
  	if candidate.length < 140 && candidate.length > 60
  		tweet = candidate
  	end
  end
  tweet = tweet[0].upcase + tweet[1..-1]
  unless tweet[-1].match(/([.!?])/)
    tweet = tweet.concat(".")
  end
  return tweet
end
