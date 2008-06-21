#!/usr/bin/env ruby

$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[lib])

require 'phrase'
require 'word_list'
require 'flickr'

class Well
  def initialize
    @buckets = Hash.new { Phrase.new }
  end
  
  def add(timestamp, phrase)
    if phrase = @last_sentence
      @buckets[timestamp] = @buckets[timestamp] + Phrase.new(phrase)
      @last_sentence = phrase
    end
  end
  
  def show(&block)
    @buckets.keys.sort.each do |timestamp|
      result = yield @buckets[timestamp]
      puts "#{timestamp}: #{result.inspect}"
    end
  end
  
  def shouts(words)
    words.grep(/[A-Z]{2,}/)
  end
end


well = Well.new

regexps = {
  "1second" => /begin = "(\d\d:\d\d:\d\d)\.\d\d\d".*">([^<]*)/,
  "10seconds" => /begin = "(\d\d:\d\d:\d)\d\.\d\d\d".*">([^<]*)/,
  "1minute" => /begin = "(\d\d:\d\d):\d\d\.\d\d\d".*">([^<]*)/
}

File.readlines(ARGV[0]).each do |line|
  matches = regexps[ARGV[1] || "10seconds"].match(line)
  if matches
    timestamp = matches[1]
    phrase = matches[2]
    well.add(timestamp, phrase)
  end
end

well.show { |p| p.words.without_stop_words }