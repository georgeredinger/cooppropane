require 'rubygems'
require 'haml'
require 'dm-migrations'
require 'dm-migrations/adapters/dm-mysql-adapter' 
require 'sinatra/base'
require 'config/database'
require 'haml'
require 'sass'
require 'logger'
require 'lib/makeplot'
require 'open-uri'
require 'lib/propane_scrape'
DataMapper.auto_upgrade!

#base.table_exists?(Price) or database.save(Price)


class SkeletonApp < Sinatra::Base
  set :session, true
  set :haml, {:format => :html5 }
  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }

  helpers do
    def link_to text, url=nil
      haml "%a{:href => '#{ url || text }'} #{ text }"
    end

    def link_to_unless_current text, url=nil
      if url == request.path_info
        text
      else
        link_to text, url
      end
    end
  end

  # SASS stylesheet
  get '/style.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end

  get '/' do
    @prices = Prices.all
    @plot = makeplot @prices
    haml :index, :layout => :'layouts/default'
  end

  get '/about' do
    haml :about, :layout => :'layouts/default'
    #query the database for prices and put in array
    # construct flot graph for view...
  end

  get '/form' do
    %{ <form action="/name" method="post">
          <input name="person" type="text">
          <input type="submit">
       </form> }
  end

  get '/update' do
    page = open("http://www.co-openergy.org/prices.html")
    prices=propane_scrape(page)
    @scrapes= prices["251-500"]
    @price_last = Prices.last
    if @scrapes.to_f.to_s != @price_last.price.to_s 
      p = Prices.new
      p.attributes = {
      :scraped_at => Time.parse(date),
      :price =>  price.to_f
      }
      p.save
    end
 
    haml :update , :layout => :'layouts/default'
    #call the update thingy here...
    #insert into database if it's new...
  end


  post '/name' do
    haml "Hello #{ params[:person] }", :layout => :'layouts/default'
  end

  get "/env" do
    haml "environment = #{ENV['RACK_ENV']}"
  end
  
  get "/user/:id" do
    "You're looking for user with id #{ params[:id] }"
  end
end


