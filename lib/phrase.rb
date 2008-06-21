class Phrase
  attr_reader :content
  
  def initialize(content = "")
    @content = content
  end
  
  def words
    WordList.new(content.gsub("<br/>", "").strip.gsub(/[^a-zA-Z0-9\s]/, " ").split(" "))
  end
  
  def +(other_phrase)
    @content += " " + other_phrase.content
  end
end