#!/usr/bin/env ruby
# Load the constituency data directly into the database

$:.unshift "#{File.dirname(__FILE__)}/lib"

require 'rubygems'
require 'csv'
require 'mysql'
require 'configuration'

conf = Configuration.new

def quote_string(s)
  s.gsub(/\\/, '\&\&').gsub(/'/, "''") # ' (for ruby-mode)
end

data = CSV.readlines("data/constituencies.csv")

# Remove the first element
data.shift

db = Mysql.real_connect(conf.database_host, conf.database_user, conf.database_password, conf.database_name)

# Clear out the old data
db.query("DELETE FROM constituency")

values = data.map {|row| "(\"#{row[0]}\", \"#{quote_string(row[1])}\", 1)" }.join(',')
db.query("INSERT INTO constituency (name, from_date, main_name) VALUES #{values}")
