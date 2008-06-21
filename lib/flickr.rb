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