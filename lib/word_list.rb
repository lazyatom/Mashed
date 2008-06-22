class WordList < Array
  def best
    nouns = proper_nouns
    return nouns.sort_by { |w| w.length }.last if nouns.any?
    good_words = without_stop_words
    return good_words.sort_by { |w| w.length }.last if good_words.any?
    sort_by { |w| w.length }.last
  end

  def shouts
    WordList.new(*self.grep(/[A-Z]{2,}/))
  end
  
  def proper_nouns
    proper_nouns = WordList.new
    self.grep(/[A-Z][a-z]/).each do |pn|
      index = self.index(pn)
      unless index == 0 || /\./.match(self[index-1])
        proper_nouns << pn
      end
    end
    proper_nouns
  end
  
  def without_stop_words
    unless @stop_words 
      @stop_words = File.readlines('stop_words')
      @stop_words.map! { |w| w.chomp.strip }
    end
    WordList.new(self.reject { |w| @stop_words.include?(w.downcase) || w.length < 3})
  end
end