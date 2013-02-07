
Person = Struct.new(:first_name, :last_name, :email_address, :homephone, :street, :city, :state, :zipcode)

class Prompt

  attr_reader :attributes
  attr_reader :first_name
  attr_reader :person
  
  def initialize
    @people = []
  end

  # def clean_phone_number(homephone)
  #   homephone = homephone.scan(/[0-9]/).join

  #   if homephone.length < 10
  #     "XXXXXXXXXX"
  #   elsif homephone.length == 10
  #     homephone
  #   elsif homephone.length == 11 && homephone[0] == 1
  #     homephone[1..-1]
  #   elsif homephone.length == 11 && homephone[0] != 1
  #     "XXXXXXXXXX"
  #   elsif homephone.length > 11
  #     "XXXXXXXXXX"
  #   else
  #     "XXXXXXXXXX"
  #   end
  # end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end

  queue = {}


  def load(filename)
    contents = CSV.open(filename, headers: true, header_converters: :symbol)
    contents.each do |row|
      first_name = row[:first_name] || ""
      last_name = row[:last_name] || ""
      email_address = row[:email_address] || ""
      phone_number = row[:homephone] || ""
      street = row[:street] || ""
      city = row[:city] || ""
      state = row[:state] || ""
      zipcode = clean_zipcode(row[:zipcode])
      person = Person.new(first_name, last_name, email_address, phone_number, street, city, state, zipcode)
      @people << person
      #info.push(person)
      #@attributes = [first_name, last_name, email_address, phone_number, street, city, state, zipcode]
      #queue = {LAST NAME => :last_name, FIRST NAME => :first_name, EMAIL => :email_address, ZIPCODE => :zipcode, CITY => :city, STATE => :state, ADDRESS => :street, PHONE => :homephone}
    end
    @people
  end

  def queue_print_by(parts)
    puts "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\tPHONE"
    @queue.each.sort_by(parts) do |person| 
      puts "#{person.last_name}\t#{person.first_name}\t#{person.email_address}\t#{person.zipcode}\t#{person.city}\t#{person.state}\t#{person.street}" 
    end
  end


  def help_differentiator(parts)
    if parts[0] == "load"
      help_command_load
    elsif parts[0] == "queue" && parts[1] == "count"
      help_command_queue_count
    elsif parts[0] == "queue" && parts[1] == "clear"
      help_command_queue_clear
    elsif parts[0] == "queue" && parts[1] == "print"
      help_command_queue_print
    elsif parts[0] == "queue" && parts[1] == "print" && parts[2] == "by"
      help_command_queue_print_by
    elsif parts[0] == "queue" && parts[1] == "save" && parts[2] == "to"
      help_command_queue_save_to
    elsif parts[0] == "find"
      help_command_find
    else 
      help_generic
    end

  end

  def help_generic
    puts "You can choose: load<filename>, help, help<command>, queue count, queue clear, queue print, queue print by<attribute>, queue save to<file name.csv>, find<attribute><criteria>"
  end

  def help_command_load
    puts "Load: Erases any loaded data and parses the specified file.  If no filename is given, it will ddefault to event_attendees.csv"
  end

  def help_command_queue_count
    puts "Queue count: Output how many records are in the current queue."
  end

  def help_command_queue_clear
    puts "Queue clear: Empties the queue."
  end

  def help_command_queue_print
    puts "Queue print: prints out a tab-delimited data table with a header row."
  end

  def help_command_queue_print_by 
    puts "Queue print by <attribute>: prints the data table sorted by the specified attribute."
  end

  def help_command_queue_save_to
    puts "Queue save to <filename.csv>: Exports the current queue to the specified file."
  end

  def help_command_find
    puts "Find <attribute> <criteria>: Loads the queue with all records matching the criteria for a certain attribute."
  end
end

