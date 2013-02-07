require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'

get '/' do
  sql = "select * from items"
  @rows = run_sql(sql)
  erb :home
end

get '/new' do
  erb :new
end

post '/create' do
  item = params[:item]
  details = params[:details]
  sql = "insert into items (item, details) values ('#{item}', '#{details}')"
  run_sql(sql)
  redirect to('/')
end

def run_sql(sql)
  conn = PG.connect(:dbname =>'todo', :host => 'localhost')
  result = conn.exec(sql)
  conn.close

  result
end
