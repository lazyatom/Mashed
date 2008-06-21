def google_map_for(lat, long)
  %{
  <iframe width="300" height="300" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://maps.google.com/?ie=UTF8&amp;s=AARTsJqzARj-Z8VnW5pkPMLMmZbqrJcYpw&amp;ll=#{lat},#{long}&amp;spn=0.004005,0.006437&amp;z=16&amp;output=embed">
  </iframe>
  }
end
