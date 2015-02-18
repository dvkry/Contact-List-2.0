

# ActiveRecord::Base.logger = Logger.new(STDOUT) 
puts "Establishing connection to database ..."
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  encoding: 'unicode',
  pool: 5,
  database: 'dabjdlvk42cjca',
  username: 'ggksuwkfoftnwz',
  password: 'aiSGpIxYTNqZJ-wPf4J-CStVqa',
  host: 'ec2-107-21-93-97.compute-1.amazonaws.com',
  port: 5432,
  min_messages: 'error'
)
puts "CONNECTED"