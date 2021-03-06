require "sinatra/activerecord"
require 'sinatra'
require './auth'
include Auth

enable :sessions

if ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end

class User < ActiveRecord::Base

end

class Article < ActiveRecord::Base

end


get '/' do
    p session
    @req = request.path
    erb :home
end

get '/articles/new' do
    if session['user_id'] == nil
        p 'User was not logged in'
        redirect '/'
    end
    erb :'/articles/new'
end

post '/articles/new' do # CREATE
    p "article published!"
    @article = Article.new(title: params['title'], content: params['content'], user_id: session['user_id'])
    @article.save
    redirect "/articles/#{@article.id}"
end

get '/articles/:id' do # READ
    @article = Article.find(params['id'])
    erb :'/articles/show'
end

get '/articles/?' do
    @articles = Article.all
    erb :'/articles/index'
end

delete '/articles/:id' do # DELETE
    @article = Article.find(params['article_id'])
    @article.destroy
    redirect "/"
end


get '/login' do # READ
   erb :'/users/login'
end

post '/login' do # CREATE
    p params
    user = User.find_by(email: params['email'])
    if user != nil
        if user.password == params['password']
            Auth::login(session, user)
            redirect "/users/#{user.id}"
        end
    end
end

post '/logout' do # DELETE
    Auth::logout(session)
end


get '/users/new' do # READ
    if session['user_id'] != nil
        p 'User was already logged in'
        redirect '/'
    end
    erb :'/users/new'
end

get '/users/:id' do # READ
    @user = User.find(params['id'])
    erb :'/users/show'
end

get '/profile' do
    @current_user = Auth::current_user
end


post '/users/new' do # CREATE
    @user = User.new(name: params['name'], email: params['email'], password: params['password'])
    @user.save
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
end
