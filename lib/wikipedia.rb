require 'rubygems'
require 'open-uri'
require 'hpricot'

def wikipedia_data_for(word)
  doc = Hpricot(open("http://en.wikipedia.org/wiki/Special:Search?search=#{word}"))
  data = { :name => (doc/"h1.firstHeading").first.inner_html, :description => (doc/"div#bodyContent/p").first.inner_html }
  
  unless (doc/"span.latitude").empty?
    data.merge!({ 
      :type => 'location',
      :lat  => (doc/"span.latitude").first.inner_html, 
      :long => (doc/"span.longitude").first.inner_html
    })
  else
    unless (doc/"span.bday").empty?
      data.merge!({ 
        :type => 'person',
        :bday => (doc/"span.bday").first.inner_html
      })
    end
  end
  
  data
# rescue
#   nil
end