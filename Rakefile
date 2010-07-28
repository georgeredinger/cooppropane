#namespace :db do
#
#  require 'config/database'
#
#  desc "Migrate the database (deletes data)"
#  task :migrate do
#    DataMapper.auto_migrate!
#  end
#
#  desc "Upgrade the database schema (data safe)"
#  task :upgrade do
#    DataMapper.auto_upgrade!
#  end
#
#  desc "Add some test data"
#  task :generate do
#  end
#
#  desc "Clear test data"
#  task :clean do
#  end
#end
#
require 'rake'
require 'rake/testtask'

task :default => :'test:units'

desc "Run unit tests"
Rake::TestTask.new('test:units') do |t|
  t.pattern = 'test/test_*.rb'
  t.verbose = true
  t.warning = true
end


