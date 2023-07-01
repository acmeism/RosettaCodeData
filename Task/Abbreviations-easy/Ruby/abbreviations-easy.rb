#!/usr/bin/env ruby

cmd_table = File.read(ARGV[0]).split
user_str = File.read(ARGV[1]).split

user_str.each do |abbr|
  candidate = cmd_table.find do |cmd|
    cmd.count('A-Z') <= abbr.length && abbr.casecmp(cmd[0...abbr.length]).zero?
  end

  print candidate.nil? ? '*error*' : candidate.upcase

  print ' '
end

puts
