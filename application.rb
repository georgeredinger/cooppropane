require 'rubygems'
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
require 'twitter'

DataMapper.auto_upgrade!

class SkeletonApp < Sinatra::Base
   set :session, true
   set :haml, {:format => :html4 }
   set :root, File.dirname(__FILE__)
   set :public_folder, Proc.new { File.join(root, "public") }
   set :raise_errors, true

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
      @prices = Prices.all(:order => [ :scraped_at.asc ])
      @plot = makeplot @prices
      haml :index, :layout => :'layouts/default'
   end

   get '/about' do
      haml :about, :layout => :'layouts/default'
			puts "Consumer_key = #{ENV['Consumer_key']}"
		puts "Consumer_secret = #{ENV['Consumer_secret']}"
		puts "Access_token = #{ENV['Access_token']}"
		puts "Access_token_secret = #{ENV['Access_token_secret']}"
   end

   get '/update' do
      @prices=checkprices
      haml :update , :layout => :'layouts/default'
   end
get '/tweet' do
  Twitter.configure do |config|
		config.consumer_key = ENV['Consumer_key']
		config.consumer_secret = ENV['Consumer_secret']
		config.oauth_token = ENV['Access_token']
		config.oauth_token_secret = ENV['Access_token_secret']
	end
  Twitter.update("I'm tweeting with @gem!")
end
end

	
