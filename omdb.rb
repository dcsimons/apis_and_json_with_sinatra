require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  response = Typhoeus.get("www.omdbapi.com", :params => {:s => search_str})
  result = JSON.parse(response.body)

  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  result["Search"].each do |movie|
    html_str += "<li><a href=/poster/#{movie['imdbID']}>Title: #{movie['Title']}<br>Year: #{movie['Year']}</a></li><br>"
    # html_str += "<li>Title: #{movie["Title"]}<br>Year: #{movie["Year"]}</li><br>"
  end

  html_str += "</ul></body></html>"

end

get '/poster/:imdbID' do |imdb_id|
  # Make another api call here to get the url of the poster.
  response = Typhoeus.get("www.omdbapi.com", :params => {:i => imdb_id})
  result = JSON.parse(response.body)


  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<br><img src = #{result["Poster"]}><br>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

