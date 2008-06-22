require 'terminator'
require 'sinatra'

subtitles = Subtitles.read(ARGV[0])

# Word Timings
# 
# 1: 8.4
# 2: 11.2
# 3: 12.5
# 4: 13.9
# 5: 16.0
# 6: 18.0
# 7: 19.8
# 8: 21.4
# 9: ?

START = 84

INTERVALS = [
  28,
  13,
  14,
  21,
  20,
  18,
  16,
]

def in_sequence(subtitles, &block)
  now = START
  current_interval = 0
  1000.times do
    interval = INTERVALS[current_interval % INTERVALS.length]
    yield subtitles.at_time(now, interval)
    now = now + interval
    current_interval += 1
  end
end

words = []
in_sequence(subtitles) { |phrase| words << (phrase.words.best || "").upcase }

get "/words.js" do
  "var messages = #{words.inspect};"
end