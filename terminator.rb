#!/usr/bin/env ruby

class Well
  def initialize
    @buckets = Hash.new { [] }
  end
  
  def add(timestamp, phrase)
    if phrase == @last_sentence
      puts "discarding: #{phrase.inspect}"
    else
      words = words_from_phrase(phrase)
      
      @buckets[timestamp] += without_stop_words(words)
      
      puts "[#{timestamp}] storing: #{phrase.inspect}"
      @last_sentence = phrase
    end
  end
  
  def words_from_phrase(phrase)
    phrase.gsub("<br/>", "").strip.gsub(/[^a-zA-Z0-9\s]/, " ").split(" ")
  end
  
  def show
    @buckets.each do |timestamp, words|
      puts "#{timestamp}: #{words.inspect}"
    end
  end
  
  def significant_words
    @buckets.keys.sort.map do |timestamp|
      best_word_in(@buckets[timestamp])
    end
  end
  
  def best_word_in(words)
    words.sort_by { |w| w.length }.last
  end
  
  def without_stop_words(words)
    unless @stop_words 
      @stop_words = File.readlines('stop_words')
      @stop_words.map! { |w| w.chomp.strip }
    end
    words.reject { |w| @stop_words.include?(w.downcase) }
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

require 'rubygems'
require 'hpricot'
require 'open-uri'

def flickr_urls_for(word)
  doc = Hpricot(open("http://www.flickr.com/search/?q=#{word}"))
  (doc/"img.pc_img")[0..2].map { |element| element["src"] }
rescue
  nil
end

def show_flickr_images(word)
  image1, image2, image3 = flickr_urls_for(word)

  if image1
    html = <<-HTML
    <html>
    <body>
      <h1>#{word}</h1>
      <img src="#{image1}">
      <img src="#{image2}">
      <img src="#{image3}">
    </body>
    </html>
    HTML
  else
    html = <<-HTML
    <html>
    <body>
      <h1>#{word}</h1>
      No images :(
    </body>
    </html>
    HTML
  end
  filename = "images.html" 
  File.open(filename, "w") { |f| f.write html }
  `open #{filename}`
end

well.show