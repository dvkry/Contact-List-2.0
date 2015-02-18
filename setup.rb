require 'active_record'


creds = {   adapter: 'postgresql',
  encoding: 'unicode',
  pool: 5,
  database: 'dabjdlvk42cjca',
  username: 'ggksuwkfoftnwz',
  password: ' xx xx xx ',
  host: 'ec2-107-21-93-97.compute-1.amazonaws.com',
  port: 5432,
  min_messages: 'error' }

# ActiveRecord::Base.logger = Logger.new(STDOUT) 
puts "Establishing connection to database ..."
ActiveRecord::Base.establish_connection( creds )
puts "CONNECTED"
