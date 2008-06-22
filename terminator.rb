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
    if phrase != @last_sentence
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
  
  def at_time(time, window)
    gathered_phrase = (time..(time + window)).inject(Phrase.new) do |phrase, timestamp|
      phrase += @buckets[timestamp]
    end
    yield gathered_phrase
  end
end


well = Well.new

timestamp_regexp = /begin = "(\d\d):(\d\d):(\d\d)\.\d\d\d".*">([^<]*)/

File.readlines(ARGV[0]).each do |line|
  matches = timestamp_regexp.match(line)
  if matches
    hours, minutes, seconds = matches[1], matches[2], matches[3]
    timestamp = (hours.to_i * 3600) + (minutes.to_i * 60) + seconds.to_i
    phrase = matches[4]
    well.add(timestamp, phrase)
  end
end

well.show { |p| p.words }

1.step(50, 2) do |time|
  puts "#{time}: #{well.at_time(time, 2) { |p| p.words.best }}"
end