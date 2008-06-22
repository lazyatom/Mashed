class Subtitles
  
  TIMESTAMP_REGEXP = /begin = "(\d\d):(\d\d):(\d\d)\.(\d)\d\d".*">([^<]*)/
  
  def self.read(filename)
    subtitles = new
    File.readlines(ARGV[0]).each do |line|
      matches = TIMESTAMP_REGEXP.match(line)
      if matches
        hours, minutes, seconds, fraction = matches[1], matches[2], matches[3], matches[4]
        timestamp = (hours.to_i * 36000) + (minutes.to_i * 600) + (seconds.to_i * 10) + fraction.to_i
        phrase = matches[5]
        subtitles.add(timestamp, phrase)
      end
    end
    subtitles
  end
  
  def initialize
    @buckets = Hash.new #{ Phrase.new }
  end
  
  def add(timestamp, phrase)
    if phrase != @last_sentence
      @buckets[timestamp] ||= Phrase.new
      @buckets[timestamp] += phrase
      @last_sentence = phrase
    end
  end
  
  def show(&block)
    @buckets.keys.sort.each do |timestamp|
      result = yield @buckets[timestamp]
    end
  end
  
  def at_time(time, window)
    gathered_phrase = (time..(time + window)).inject(Phrase.new) do |phrase, timestamp|
      phrase += @buckets[timestamp] if @buckets[timestamp]
      phrase
    end
    yield gathered_phrase if block_given?
    gathered_phrase
  end
end