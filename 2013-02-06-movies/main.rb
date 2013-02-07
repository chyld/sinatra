require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'httparty'
require 'json'
require 'pg'

get '/movies' do
  sql = 'select poster from movies'

  conn = PG.connect(:dbname =>'movie_app', :host => 'localhost')
  @rows = conn.exec(sql)
  conn.close
  erb :posters
end

get '/' do
  if params[:title].present?
    name = params[:title].gsub(' ', '+')
    url = "http://www.omdbapi.com/?t=#{name}"
    html = HTTParty.get(url)
    @hash = JSON(html)

    sql = "insert into movies (title, year, rated, released, runtime, genre, director, writers, actors, plot, poster) values ('#{@hash['Title']}', '#{@hash['Year']}', '#{@hash['Rated']}', '#{@hash['Released']}', '#{@hash['Runtime']}', '#{@hash['Genre']}', '#{@hash['Director']}', '#{@hash['Writer']}', '#{@hash['Actors']}', '#{@hash['Plot']}', '#{@hash['Poster']}')"

    conn = PG.connect(:dbname =>'movie_app', :host => 'localhost')
    conn.exec(sql)
    conn.close
  end

  erb :movie
end
