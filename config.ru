require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))

require './server'

run Sinatra::Application