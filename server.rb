require './initializer'

class Mark

  def generate_fact
    candidate = gabbler
    if (110..140) === candidate.length && good_grammar?(candidate)
      return candidate
    else
      generate_tweet
    end
  end

  def initialize(dict_location = 'dictionaries/hot.txt')
    @dict_location = dict_location
  end

  def gabbler
    unless @gabbler
      @gabbler = Gabbler.new(:depth => 3)
      @gabbler.learn(File.read(@dict_location))
    end
    @gabbler
  end

  private

  def good_grammar?(string)
    grammar_checker = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    page = grammar_checker.get('http://www.link.cs.cmu.edu/link/submit-sentence-4.html')
    sentence_form = page.forms.first

    sentence_form.fields.first.value = string
    result = grammar_checker.submit(sentence_form)
    linkages = result.search('pre').last.content

    return true unless linkages['No linkages found'] || linkages['Found 1 linkage']
  end

end