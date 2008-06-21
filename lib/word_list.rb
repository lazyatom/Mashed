class WordList < Array
  def best
    without_stop_words.proper_nouns.sort_by { |w| w.length }.last
  end
  
  def proper_nouns
    proper_nouns = WordList.new
    words.grep(/[A-Z][a-z]/).each do |pn| 
      proper_nouns << (words.index(pn) == 0 || /\./.match(words[words.index(pn)-1]) ? pn : nil )
    end
    proper_nouns
  end
  
  def without_stop_words
    unless @stop_words 
      @stop_words = File.readlines('stop_words')
      @stop_words.map! { |w| w.chomp.strip }
    end
    good_words = WordList.new
    words.each { |w| good_words << w if @stop_words.include?(w.downcase) }
    good_words
  end
end