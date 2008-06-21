require 'rubygems'
require 'hpricot'
require 'open-uri'

def wikipedia_data_for(word)
  doc = Hpricot(open("http://en.wikipedia.org/wiki/Special:Search?search=#{word}&fulltext=Search"))
  data = { :description => doc.at("//div[@class='bodyContent]/p") }
  
  if doc.at("//span[@class='latitude']")
    data.merge!({ 
      :type => 'location',
      :lat => doc.at("//span[@class='latitude']"), 
      :long => doc.at("//span[@class='longitude']"), 
    })
  elseif doc.at("//span[@class='bday']")
  data.merge!({ 
      :type => 'person',
      :bday => doc.at("//span[@class='bday']")
    })
  end
rescue
  nil
end