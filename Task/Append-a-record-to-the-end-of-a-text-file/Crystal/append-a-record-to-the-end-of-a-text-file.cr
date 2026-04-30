record PasswdEntry, account : String, password : String, uid : Int32, gid : Int32,
       gecos : Gecos, directory : String, shell : String do
  def to_s (io)
    io << account << ":" << password << ":" << uid.to_s << ":" << gid.to_s << ":"
    gecos.to_s(io)
    io << ":" << directory << ":" << shell
  end
end

record Gecos, fullname : String, office : String, extension : String, homephone : String, email : String do
  def to_s (io)
    io << fullname << "," << office << "," << extension << ","
    io << homephone << "," << email
  end
end

filename = "rosetta.passwd"

File.open(filename, "w") do |f|
  f.puts PasswdEntry.new("jsmith", "x", 1001, 1000,
                         Gecos.new("Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org"),
                         "/home/jsmith", "/bin/bash")
  f.puts PasswdEntry.new("jdoe", "x", 1002, 1000,
                         Gecos.new("Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org"),
                         "/home/jdoe", "/bin/bash")
end

File.open(filename, "a")  do |f|
  f.puts PasswdEntry.new("xyz", "x", 1003, 1000,
                         Gecos.new("X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org"),
                         "/home/xyz", "/bin/bash")
end

lines = File.read_lines(filename)

puts "Appended record (##{lines.size}): " + lines.last
