require "rubygems"
require "bundler"
Bundler.setup

require 'yaml'
require 'twitter'
require 'gabbler'
require 'sinatra'
require 'mechanize'

ENVIRONMENT = "development"
APP_CONFIG = YAML.load(File.read("config/config.yml"))[ENVIRONMENT]

Twitter.configure do |config|
  config.consumer_key = APP_CONFIG[:twitter][:consumer_key]
  config.consumer_secret = APP_CONFIG[:twitter][:consumer_secret]
  config.oauth_token = APP_CONFIG[:twitter][:oauth_token]
  config.oauth_token_secret = APP_CONFIG[:twitter][:oauth_token_secret]
end

#load dictionary
MARK = Gabbler.new(:depth => 3)
@dictionary = File.read('config/dictionary.txt')
MARK.learn(@dictionary)