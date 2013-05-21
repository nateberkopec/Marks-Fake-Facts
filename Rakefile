require 'dotenv/tasks'

task :environment => :dotenv do
  require './server'
end

task :dictbuild => :environment do
	# if building your own twitterbot, you'll probably need to completely rewrite this
	# to get your own dictionary file, this is all custom for wikipedia
	agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
	page = agent.get('http://en.wikipedia.org/wiki/Wikipedia:Recent_additions')

	fact_links = page.links_with(:href => %r(\/wiki\/Wikipedia:Recent_additions\/\d{4}))
	fact_links.each do |fact_page|

		facts = []

		page = agent.get "http://en.wikipedia.org" + fact_page.href
		facts = page.search("#bodyContent .mw-content-ltr ul li")

		dictionary = []

		facts.each do |fact|
			fact = fact.content
			next unless fact['...'] && !fact['Did you know'] && !fact['Wikinews']
			fact.gsub!("... that ","")
			fact.gsub!("...that ","")
			fact.chop!
			fact.gsub!(/\(.+\)/,"")
			dictionary.push(fact)
		end

	  File.open('config/dictionary.txt', 'a') do |f|
	  	dictionary.each do |fact|
	  		f.puts(fact)
	  	end
	  end
	end
end

task :tweet => :environment do
  mark = Mark.new("dictionaries/#{dictionaries.sample}.txt")
  if Time.now.hour % 3 == 0
    Twitter.update(mark.generate_fact)
  end
end

task :tweet => :environment do
  mark = Mark.new("dictionaries/#{dictionaries.sample}.txt")
  Twitter.update(mark.generate_fact)
end

desc "Open an irb session preloaded with emmetty goodness"
task :console do
  sh "irb -rubygems -I . -r initializer.rb"
end

