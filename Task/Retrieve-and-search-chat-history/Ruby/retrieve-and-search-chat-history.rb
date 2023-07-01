#! /usr/bin/env ruby
require 'net/http'
require 'time'

def gen_url(i)
  day = Time.now + i*60*60*24
  # Set the time zone in which to format the time, per
  # https://coderwall.com/p/c7l82a/create-a-time-in-a-specific-timezone-in-ruby
  old_tz = ENV['TZ']
  ENV['TZ'] = 'Europe/Berlin'
  url = day.strftime('http://tclers.tk/conferences/tcl/%Y-%m-%d.tcl')
  ENV['TZ'] = old_tz
  url
end

def main
  back = 10
  needle = ARGV[0]
  (-back..0).each do |i|
    url = gen_url(i)
    haystack = Net::HTTP.get(URI(url)).split("\n")
    mentions = haystack.select { |x| x.include? needle }
    if !mentions.empty?
      puts "#{url}\n------\n#{mentions.join("\n")}\n------\n"
    end
  end
end

main
