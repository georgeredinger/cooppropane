# data-mapper models go here
require 'dm-types'
class Prices 
  include DataMapper::Resource
  property :id, Serial
  property :scraped_at, EpochTime
  property :price, Float
end

