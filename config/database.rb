require 'rubygems'
require 'sinatra'
require 'dm-core'
require_relative '../models'
#gem 'dm-sqlite-adapter', '~> 1.0.0' 
require  'dm-migrations'
DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
#
#env=ENV['RACK_ENV'] || "development"
#puts env
#case env 
#  when 'cucumber'
#    # local machine - test
#    puts "using cucumber database"
#    DataMapper.setup(:default, {
#      :database => 'ideator_cuke',
#      :adapter  => 'postgres'
#    })
#  when 'production'
#    DataMapper.setup( ENV['DATABASE_URL'] || {
#      :database => 'production',
#      :adapter  => 'postgres'
#    })
#  when 'development'
#    DataMapper.setup(:default, {
#        :adapter  => 'sqlite3',
#        :host     => 'localhost',
#        :username => '',
#        :password => '',
#        :database => 'db/development.sql'
#    })
#  else
#    raise  "AFit"
#  end


