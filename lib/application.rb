require_relative 'contact'
require 'pg'
require 'colorize'

class Application

  def help
    puts "Here is a list of available commands:".green
    puts "      new".blue + " - Create a new contact"
    puts "     list".blue + " - List all contacts"
    puts "     show".blue + " - Show a contact"
    puts "     find".blue + " - Find a contact (by id)" 
    puts "firstname".blue + " - Find contacts (by firstname)" 
    puts " lastname".blue + " - Find contacts (by lastname)" 
    puts "    email".blue + " - Find a contact (by E-mail)" 
    puts "  destroy".red + " - Destroy contact (by id)"
    puts '' #extra line for readability
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

  def find_email(email)
    contact = Contact.find_by_email(email)
    puts "Not Found!".red if contact == nil
    display(contact)
  end

  def find_lastnames(name)
    contacts = Contact.find_all_by_lastname(name)
    puts "Not Fount!".red if contacts.length == 0
    contacts.each do |contact|
      display(contact)
    end
  end

  def find_firstname(name)
    contacts = Contact.find_all_by_firstname(name)
    puts "Not Fount!".red if contacts.length == 0
    contacts.each do |contact|
      display(contact)
    end
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
    when 'lastname'
      find_lastnames(ARGV[1])
    when 'firstname'
      find_firstname(ARGV[1])
    when 'email'
      find_email(ARGV[1])
    else
      help
    end
  end
end

app = Application.new
app.command(ARGV.first.downcase)