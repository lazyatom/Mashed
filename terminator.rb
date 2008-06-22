#!/usr/bin/env ruby

$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[lib])

require 'phrase'
require 'word_list'
require 'flickr'
require 'wikipedia'
require 'subtitles'
# 
# subtitles = Subtitles.read(ARGV[0])
# 
# subtitles.show { |p| p.words }
# 
# 1.step(50, 2) do |time|
#   puts "#{time}: #{subtitles.at_time(time, 2) { |p| p.words.best }}"
# end

