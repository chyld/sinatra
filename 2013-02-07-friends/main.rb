require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'

get '/' do
  erb :home
end

get '/new' do
  erb :new
end

get '/friends' do
  sql = "select * from friends"
  @rows = run_sql(sql)
  erb :friends
end

post '/create' do
  sql = "insert into friends (name, age, gender, image, twitter, github) values ('#{params['name']}', '#{params['age']}', '#{params['gender']}', '#{params['image']}', '#{params['twitter']}', '#{params['github']}')"
  run_sql(sql)
  redirect to('/friends')
end

def run_sql(sql)
  conn = PG.connect(:dbname =>'friends', :host => 'localhost')
  result = conn.exec(sql)
  conn.close
  result
end
