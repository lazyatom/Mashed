def wikipedia_data_for(word)
  doc = Hpricot(open("http://en.wikipedia.org/wiki/Special:Search?search=#{word}&fulltext=Search"))
  if doc.at("//span[@class='latitude']")
    { 
      :type => 'location',
      :lat => doc.at("//span[@class='latitude']"), 
      :long => doc.at("//span[@class='longitude']"), 
      :description => doc.at("//div[@class='bodyContent]/p")
    }
  elseif doc.at("//span[@class='bday']")
    {
      :type => 'person',
      :bday => doc.at("//span[@class='bday']")
    }
  end
rescue
  nil
end