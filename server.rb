require 'sinatra'
require './initializer'

get '/' do
  # show some generic stuff, documentation about mark, last tweet, etc
  @tweet = Twitter.home_timeline.first['text']
  haml :index
end

def generate_tweet
  candidate = MARK.sentence.sentenceize!
  if (110..140) === candidate.length && candidate.good_grammar?
    return candidate
  else
    generate_tweet
  end
end

class String
  def sentenceize!
    self.replace(self[0].upcase + self[1..-1])
    unless self[-1].match(/([.!?])/)
      self.replace(self + ".")
    end
  end

  def good_grammar?
    grammar_checker = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    page = grammar_checker.get('http://www.link.cs.cmu.edu/link/submit-sentence-4.html')
    sentence_form = page.forms.first
    
    sentence_form.fields.first.value = self
    result = grammar_checker.submit(sentence_form)
    linkages = result.search('pre').last.content
    
    return true unless linkages['No linkages found'] || linkages['Found 1 linkage']
  end
end