require 'sinatra'
require 'twitter'
require 'yaml'
require 'haml'
require 'gabbler'

configure do
	ENVIRONMENT = "development"
	raw_config = File.read("config/config.yml")
	APP_CONFIG = YAML.load(raw_config)[ENVIRONMENT]

	Twitter.configure do |config|
	  config.consumer_key = APP_CONFIG[:twitter][:consumer_key]
	  config.consumer_secret = APP_CONFIG[:twitter][:consumer_secret]
	  config.oauth_token = APP_CONFIG[:twitter][:oauth_token]
	  config.oauth_token_secret = APP_CONFIG[:twitter][:oauth_token_secret]
	end

	#load dictionary
	MARK = Gabbler.new
	@dictionary = File.read('config/dictionary.txt')
	MARK.learn(@dictionary)
end

get '/' do
	# show some generic stuff, documentation about mark, last tweet, etc
	@tweet = generate_tweet
  haml :index
end

def generate_tweet
	tweet = false
	until tweet
  	candidate = MARK.sentence
  	if candidate.length < 140 && candidate.length > 80
  		tweet = candidate
  		tweet[0].upcase!
  	end
  end
  return tweet
end
