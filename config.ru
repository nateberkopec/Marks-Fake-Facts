require File.expand_path(File.join(*%w[ config configuration ]), File.dirname(__FILE__))

require './server'

run Sinatra::Application