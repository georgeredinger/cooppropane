#!/usr/bin/env ruby
require 'rubygems'
require 'dm-core'
require 'dm-migrations/adapters/dm-mysql-adapter' 

   
# Open the database test1.db
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/test1.db" )
      
class Person
include DataMapper::Resource
  property :firstname, String
  property :lastname, String
  property :email, String, :key => true
end


DataMapper.auto_migrate!
p = Person.new
p.attributes = {
       :firstname => 'John',
       :lastname => 'Doe',
       :email => 'john.doe@email.com'
}

p.save

p.lastname = 'Smith'
p.save

p2 = Person.new
p2.email = 'testing@testing.com'
p2.save
     
p2.destroy

p3 = Person.get('john.doe@email.com')
puts p3.inspect

