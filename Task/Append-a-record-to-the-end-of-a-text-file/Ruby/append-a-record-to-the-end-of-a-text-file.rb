Gecos = Struct.new :fullname, :office, :extension, :homephone, :email
class Gecos
  def to_s
    "%s,%s,%s,%s,%s" % [fullname, office, extension, homephone, email]
  end
end

# Another way define 'to_s' method
Passwd = Struct.new(:account, :password, :uid, :gid, :gecos, :directory, :shell) do
  def to_s
    to_a.map(&:to_s).join(':')
  end
end

jsmith = Passwd.new('jsmith','x',1001, 1000, Gecos.new('Joe Smith', 'Room 1007', '(234)555-8917', '(234)555-0077', 'jsmith@rosettacode.org'), '/home/jsmith', '/bin/bash')
jdoe = Passwd.new('jdoe','x',1002, 1000, Gecos.new('Jane Doe', 'Room 1004', '(234)555-8914', '(234)555-0044', 'jdoe@rosettacode.org'), '/home/jdoe', '/bin/bash')
xyz = Passwd.new('xyz','x',1003, 1000, Gecos.new('X Yz', 'Room 1003', '(234)555-8913', '(234)555-0033', 'xyz@rosettacode.org'), '/home/xyz', '/bin/bash')

filename = 'append.records.test'

# create the passwd file with two records
File.open(filename, 'w') do |io|
  io.puts jsmith
  io.puts jdoe
end

puts "before appending:"
puts File.readlines(filename)

# append the third record
File.open(filename, 'a') do |io|
  io.puts xyz
end

puts "after appending:"
puts File.readlines(filename)
