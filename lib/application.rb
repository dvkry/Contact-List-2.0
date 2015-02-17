require_relative 'contact'
require 'pg'
require 'colorize'


class Application


  def help
    puts "Here is a list of available commands:"
    puts "  new  - Create a new contact"
    puts "  list - List all contacts"
    puts "  show - Show a contact"
    puts "  find - Find a contact"
  end

  def wait_for_key
    print "Press any key to continue"
    STDIN.getch
    puts '' # throw a new line in
  end

  def display(contact)
      puts 'Contact id: ' + contact.id.blue
      puts '  Name    : ' + contact.firstname.red + ' ' + contact.lastname.red
      puts '  Email   : ' + contact.email.green
      puts ''
  end

  def list
    contacts = Contact.all

    pause_counter = 0

    contacts.each do |contact|
      wait_for_key if (pause_counter % 5 == 0) && (pause_counter != 0) # Pause every 5, but not initially
      display(contact)
      # puts 'Contact id: ' + contact.id.blue
      # puts '  Name    : ' + contact.firstname.red + ' ' + contact.lastname.red
      # puts '  Email   : ' + contact.email.green
      # puts ''

      pause_counter += 1
    end
  end

  def create_new
    print "E-mail: "
    email = STDIN.gets.chomp
    print "First name: "
    firstname = STDIN.gets.chomp
    print "Last name: "
    lastname = STDIN.gets.chomp

    contact = Contact.new(firstname, lastname, email)
    contact.save
  end

  def find(id)
    display(Contact.find(id))
  end
  
  def are_you_sure?
    print "Are you sure? (type 'yes') ".red
    STDIN.gets.chomp.downcase == 'yes' # true if user types yes, false otherwise
  end

  def destroy(id)
    contact = Contact.find(id)
    display(contact)
    if are_you_sure?
      contact.destroy
      puts '...Destroyed'
    else
      puts 'Aborted'
    end
  end

  def command(arg)
    case arg
    when 'help'
      help
    when 'new'
      create_new
    when 'list'
      list
    when 'find'
      find(ARGV[1].to_i)
    when 'destroy'
      destroy(ARGV[1].to_i)
    end
  end

end

# class Help

# end

# class CreateNew
#   def self.run
#     print "E-mail: "
#     email = STDIN.gets.chomp
#     if Contact.dups_by_email(email)
#       puts "That E-mail already exists"
#     else
#       print "Name: "
#       name = STDIN.gets.chomp
#       print "Would you like to add the phone numbers?"
#       response = STDIN.gets.chomp.downcase
#       phone_hash = {}
#       while response == 'yes'
#         print "Lable: "
#         lable = STDIN.gets.chomp
#         print "Number: "
#         number = STDIN.gets.chomp
#         phone_hash[lable] = number
#         print "add another number? "
#         response = STDIN.gets.chomp.downcase
#       end
#       id = Contact.create(name, email, phone_hash) # ID is the line number
#       puts id #return id
#     end
#   end
# end

# class List
#   def self.wait_for_key
#     print "any key to continue"
#     STDIN.getch
#   end
#   def self.run
#     contact_list = ContactDatabase.new.read_from_file
#     id_counter = 1
#     contact_list.each do |contact|
#       puts id_counter.to_s + ": " + contact.name + " (" + contact.email.strip + ")"
#       puts contact.phone_nums if contact.phone_nums != {}
#       id_counter += 1 # we know that each contact is on it's 'id' line
#       wait_for_key if (id_counter - 1) % 5 == 0
#     end
#   end
# end

# class Find
#   def self.run(id)
#     found = Contact.find(id)
#     if found != []
#       found.each do |contact|
#         puts contact.name
#         puts contact.email
#       end
#     else
#       puts "Not found"
#     end
#   end
# end

app = Application.new
app.command(ARGV.first)