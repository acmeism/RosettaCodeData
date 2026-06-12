#!/usr/bin/env ruby

# == Synopsis
#
# pargs: Phone a friend
#
# == Usage
#
# pargs [OPTIONS]
#
# --help, -h:
#    show usage
#
# --eddy, -e <message>
#    call eddy
#
# --danial, -d <message>
#    call daniel
#
# --test, -t
#    run unit tests

require "getoptlong"
require "rdoc/usage"

def phone(name, message)
	puts "Calling #{name}..."
	puts message
end

def test
	phone("Barry", "Hi!")
	phone("Cindy", "Hello!")
end

def main
	mode = :usage

	name = ""
	message = ""

	opts=GetoptLong.new(
		["--help", "-h", GetoptLong::NO_ARGUMENT],
		["--eddy", "-e", GetoptLong::REQUIRED_ARGUMENT],
		["--daniel", "-d", GetoptLong::REQUIRED_ARGUMENT],
		["--test", "-t", GetoptLong::NO_ARGUMENT]
	)

	opts.each { |option, value|
		case option
		when "--help"
			RDoc::usage("Usage")
		when "--eddy"
			mode = :call
			name = "eddy"
			message = value
		when "--daniel"
			mode = :call
			name = "daniel"
			message = value
		when "--test"
			mode = :test
		end
	}

	case mode
	when :usage
		RDoc::usage("Usage")
	when :call
		phone(name, message)
	when :test
		test
	end
end

if __FILE__==$0
	begin
		main
	rescue Interrupt => e
		nil
	end
end
