require "json"

DB = "DATABASE"

record Entry, timestamp : Time, description : String, category : String do
  include JSON::Serializable
  def to_s (io)
    timestamp.to_s(io, "%F %T")
    io << " - " << description
    io << " [" << category << "]" if category != ""
  end
end

def load
  File.open(DB) do |f|
    Array(Entry).from_json f
  end
rescue File::NotFoundError
  [] of Entry
end

def save (entries)
  File.open(DB, "w") do |f|
    entries.to_json f
  end
end

def usage (errmsg = nil)
  puts errmsg if errmsg
  print <<-EOU
Usage: #{PROGRAM_NAME} COMMAND ARGS...
  Commands:
    add DESCRIPTION [CATEGORY] - add entry
    last                       - show last entry
    lest                       - show last in each category
    list                       - show all entries
EOU
  exit
end

def check_args (ok)
  usage "Invalid number of arguments" unless ok
end

cmd  = ARGV.shift? || usage

db = load

if cmd.in?({"help", "h", "-h"})
  usage
elsif cmd.in?({"a", "add", "-a"})
  check_args 1 <= ARGV.size <= 2
  db << Entry.new Time.local, ARGV[0], ARGV[1]? || ""
  save db
else
  check_args ARGV.size == 0
  if cmd == "last"
    puts db[-1]?
  elsif cmd == "lest"
    db.group_by(&.category).to_a.sort_by!(&.[0]).map {|_, es| es.last}.each do |e|
      puts e
    end
  elsif cmd == "list"
    db.each do |e| puts e end
  else
    usage "Invalid command '#{cmd}'"
  end
end
