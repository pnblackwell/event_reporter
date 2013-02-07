require 'csv'
require_relative 'clean_phone_number'
require_relative 'prompt'


class EventReporter



	def initialize
		@people = []
		@queue = []
		@header_list = ["last_name", "first_name", "email_address", "zipcode", "city", "state", "address", "phone_number"]
		run
	end

	def run
		command = ""
		while command != "q"
			printf "enter command:"
			input = gets.chomp 
			parts = input.split(" ")
			command = parts[0]
			case command
			when 'q' then puts "Goodbye!"
			when 'load' then load(parts[1])
			when 'help' then help(parts[1..-1])
			when 'queue' then queue_finder(parts[1..-1])
			when 'find' then find(parts[1..-1])
			else
				puts "Please print out a valid command. For suggestions, type help."
			end
		end
	end

	def load(filename)
		if filename.nil?
			filename = "event_attendees.csv"
		end
		@people = Prompt.new.load(filename)
	end

	def help(parts)
		Prompt.new.help_differentiator(parts)
	end

	def find(parts)
		attribute = parts[0]
		criteria = parts[1..-1].join(" ")
		
		@queue = @people.select { |person| person[attribute].downcase == criteria.downcase }
		# puts @queue
	end

	def queue_print
		puts "LAST NAME\t\tFIRST NAME\t\tEMAIL\t\tZIPCODE\t\tCITY\t\tSTATE\t\tADDRESS\t\tPHONE"
		@queue.each do |person| 
			puts "#{person.last_name}\t\t#{person.first_name}\t\t#{person.email_address}\t\t#{person.zipcode}\t\t#{person.city}\t\t#{person.state}\t\t#{person.street}" 
		end
	end

	def queue_finder(parts)
		#command = parts[0]

		#criteria = parts[1..-1]
		if parts.length == 1
		#if	command.length == 1
			case parts.join(" ")
			when 'count' then
				puts @queue.count
			when 'clear' then
				@queue = []
			when 'print' then
				queue_print
			else
				"invalid entry"
			end
		else 
			case parts[0..1].join(" ")
			when 'print by' then
				queue_print_by(parts)
			when 'save to' then
				queue_save_to(parts[-1])
			else
				"invalid entry"
			end
		end
	end

	def queue_print_by(parts)
		puts "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\tPHONE"
		@queue.each do |person| 
			person[attribute.to_sym]
			puts "#{person.last_name}\t#{person.first_name}\t#{person.email_address}\t#{person.zipcode}\t#{person.city}\t#{person.state}\t#{person.street}" 
		end
	end
  
  def queue_save_to(filename)
  	Dir.mkdir("output") unless Dir.exists? "output"
  	filename = filename
  	CSV.open("#{filename}", "w") do |newfile|
  		newfile << @header_list.map {  |header| header.upcase.gsub("_", " ") }
  	@queue.each { |person| newfile << [person.last_name, person.first_name, person.email_address, person.zipcode, person.city, person.state, person.street]}
  	end
  end
  end

			


EventReporter.new