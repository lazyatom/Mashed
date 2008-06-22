class Phrase
  attr_reader :content
  
  def initialize(content = "")
    @content = content
  end
  
  def words
    WordList.new(content.gsub("<br/>", "").strip.gsub(/[^a-zA-Z0-9\s]/, " ").split(" "))
  end
  
  def +(other_phrase)
    other_phrase = other_phrase.content if other_phrase.is_a?(Phrase)
    @content += (" " + other_phrase)
    self
  end
end