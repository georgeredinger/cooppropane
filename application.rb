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
require 'lib/check_prices'

DataMapper.auto_upgrade!

require 'newrelic_rpm' if  defined? Heroku
require 'exceptional'  if  defined? Heroku


class SkeletonApp < Sinatra::Base
   set :session, true
   set :haml, {:format => :html5 }
   set :root, File.dirname(__FILE__)
   set :public, Proc.new { File.join(root, "public") }
   set :raise_errors, true
   use Rack::Exceptional, '67f8f0eb4c2455a00f11d7c080b98f8ca89c3234' if defined? Heroku

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
      @prices = Prices.by_date
      @plot = makeplot @prices
      haml :index, :layout => :'layouts/default'
   end

   get '/about' do
      haml :about, :layout => :'layouts/default'
   end

   get '/update' do
      @prices=checkprices
      haml :update , :layout => :'layouts/default'
   end
end

