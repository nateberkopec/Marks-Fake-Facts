require File.expand_path(File.join(*%w[ config configutration ]), File.dirname(__FILE__))

require './server'

run Sinatra::Application