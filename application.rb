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
   end

end

