require 'terminator'

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

INTERVALS.map! { |i| i + 1 }

def in_sequence(words, subtitles, &block)
  now = START
  current_interval = 0
  words.times do
    interval = INTERVALS[current_interval % INTERVALS.length]
    puts "[#{now}, #{interval}]"
    yield subtitles.at_time(now, interval)
    now = now + interval
    current_interval += 1
  end
end

$backup_words = []

def best_word_in(phrase)
  best_word = phrase.words.best
  if best_word
    result = best_word
    $backup_words = phrase.words.dup
    $backup_words.delete(best_word)
    puts "best word: #{best_word.inspect} (from #{phrase.words.inspect})"
    puts " >>> backups: #{$backup_words.inspect}"
  else
    backup_word = $backup_words[rand($backup_words.length)]
    if backup_word
      $backup_words.delete(backup_word)
      result = backup_word
      puts "backup word: #{backup_word}"
    else
      puts "no backup word!"
    end
  end
  result
end


if ARGV[1] == 'serve'
  require 'sinatra'
  
  words = []
  in_sequence(1000, subtitles) do |phrase| 
    words << best_word_in(phrase)
  end
  words.map! { |word| word ? word.upcase : "" }
  
  get "/words.js" do
js = <<-EOJS
var messages = #{words.inspect}; 
var currentMovie = "";
var mainLoopDuration = 17500;
var introDuration = 9000;

function swapMovies() {
  document.getElementById(currentMovie).className = "movie offScreen";
  if (currentMovie == "movie1") {
   currentMovie = "movie2";
  } else {
   currentMovie = "movie1";
  }
  document.getElementById(currentMovie).className = "movie";
  setTimeout(swapMovies, mainLoopDuration);
  setTimeout(addMovieToInactiveDiv, mainLoopDuration - introDuration);
}

function addMovieToInactiveDiv() {
  if (currentMovie == "movie1") {
   var element = document.getElementById("movie2");
  } else {
   var element = document.getElementById("movie1");
  }
  var embedTag = '<h1>' + element.id + '</h1>';

  var nextMessages = messages.splice(0, 9);
  var messageStr = "";
  for(i = 0; i < nextMessages.length; i++) { messageStr += nextMessages[i] + ',' }

  console.log("queueing up words: " + messageStr);

  embedTag += '<embed width="700" height="500" quality="high"';
  embedTag += ' name="PluginObject_plugin_gbL4xY949Bc0765916b4"';
  embedTag += ' id="PluginObject_plugin_gbL4xY949Bc0765916b4"';
  embedTag += ' flashvars="messages=' + messageStr + '"';
  embedTag += ' src="/dylan_flash/dylan.swf" type="application/x-shockwave-flash"/>';
  element.innerHTML = embedTag;
}

window.onload = function() {
  addMovieToInactiveDiv();
  currentMovie = "movie1";
  setTimeout(addMovieToInactiveDiv, mainLoopDuration)
  setTimeout(swapMovies, mainLoopDuration + introDuration);
}
EOJS
  end
  
else # debugging
  
  words = []
  in_sequence(10, subtitles) do |phrase| 
    words << best_word_in(phrase)
  end
  p words
  
end