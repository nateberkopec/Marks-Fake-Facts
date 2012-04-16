require 'sinatra'
require 'twitter'
require 'yaml'
require 'haml'
require 'gabbler'
require 'mechanize'

get '/' do
	# show some generic stuff, documentation about mark, last tweet, etc
	@tweet = generate_tweet
  haml :index
end

def generate_tweet
  agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
	tweet = false
  page = agent.get('http://www.link.cs.cmu.edu/link/submit-sentence-4.html')
	sentence_form = page.forms.first
  until tweet
  	candidate = MARK.sentence
  	if candidate.length < 140 && candidate.length > 60
      tweet = candidate
      tweet = tweet[0].upcase + tweet[1..-1]
      unless tweet[-1].match(/([.!?])/)
        tweet = tweet.concat(".")
      end
      sentence_form.fields.first.value = tweet
      result = agent.submit(sentence_form)
      linkages = result.search('pre').last.content
      if linkages['No complete linkages']
        tweet = nil
      end
    end
  end
  return tweet
end
