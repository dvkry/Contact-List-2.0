require 'pg'

class Contact
  attr_reader :id
  attr_accessor :firstname, :lastname, :email

  def initialize(firstname, lastname, email, id = nil)
    @id = id
    @firstname = firstname
    @lastname = lastname
    @email = email
  end

  def save
    if @id #if it has an id, it's an update, else it's a create
      #update
      self.class.connection.exec_params("UPDATE contacts SET firstname = $1, lastname = $2, email = $3 WHERE id = $4;", [@firstname, @lastname, @email, @id])
    else
      self.class.connection.exec_params("INSERT INTO contacts ( firstname, lastname, email ) VALUES ( $1, $2, $3 );", [@firstname, @lastname, @email])
      #create
    end
  end

  def destroy
    self.class.connection.exec_params( "DELETE FROM contacts WHERE \"id\" = $1;", [@id])
  end

  def self.connection
    return @conn if @conn
    @conn = PG.connect(dbname: 'dabjdlvk42cjca', host: 'ec2-107-21-93-97.compute-1.amazonaws.com', user: 'ggksuwkfoftnwz', password: 'aiSGpIxYTNqZJ-wPf4J-CStVqa')
  end

  def self.all
    contacts = []
    connection.exec( "SELECT * FROM contacts;" ) do |records|
      records.each do |record|
        contacts << Contact.new(record['firstname'], record['lastname'], record['email'], record['id'])
      end
    end
    contacts
  end

  def self.find(id)
    connection.exec_params( "SELECT * FROM contacts WHERE \"id\" = $1", [id]) do |records|
      records.each do |record|
        return Contact.new(record['firstname'], record['lastname'], record['email'], record['id'])
      end
    end
  end

  def self.find_by_email(email)
    connection.exec_params( "SELECT * FROM contacts WHERE \"email\" = $1", [email]) do |records|
      records.each do |record|
        return Contact.new(record['firstname'], record['lastname'], record['email'], record['id'])
      end
    end
  end

  def self.find_all_by_lastname(name)
    return_records = []
    connection.exec_params( "SELECT * FROM contacts WHERE \"lastname\" = $1", [name]) do |records|
      records.each do |record|
        return_records << Contact.new(record['firstname'], record['lastname'], record['email'], record['id'])
      end
    end
    return_records
  end

  def self.find_all_by_firstname(name)
    return_records = []
    connection.exec_params( "SELECT * FROM contacts WHERE \"firstname\" = $1", [name]) do |records|
      records.each do |record|
        return_records << Contact.new(record['firstname'], record['lastname'], record['email'], record['id'])
      end
    end
    return_records
  end
end
