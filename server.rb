require 'sinatra'
require 'twitter'
require 'yaml'
require 'haml'
require 'gabbler'
require 'mechanize'

get '/' do
  # show some generic stuff, documentation about mark, last tweet, etc
  @tweet = Twitter.home_timeline.first['text']
  haml :index
end

def generate_tweet
  # The next line feels bad.
  tweet = false
  until tweet
    candidate = MARK.sentence
    if candidate.length < 140 && candidate.length > 110
      candidate = candidate.sentenceize
      if check_grammar(candidate)
        tweet = candidate
      end
    end
  end
  return tweet
end

class String
  def sentenceize
    # Fuck you, I'd rather write Javascript.
    this = self
    this = this[0].upcase + this[1..-1]
    unless this[-1].match(/([.!?])/)
      return this.concat(".")
    end
    return this
  end
end

def check_grammar(candidate)
  # 
  # This is grey hat as FUCK, please don't tell anyone.
  # TODO: Make this use a local copy of a link-grammar checker, not a shitty not-API.
  #
  grammar_checker = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  page = grammar_checker.get('http://www.link.cs.cmu.edu/link/submit-sentence-4.html')
  sentence_form = page.forms.first
  sentence_form.fields.first.value = candidate
  result = grammar_checker.submit(sentence_form)
  linkages = result.search('pre').last.content
  return !linkages['No linkages found'] || !linkages['Found 1 linkage']
end