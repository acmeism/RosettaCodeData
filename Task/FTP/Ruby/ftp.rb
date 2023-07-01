require 'net/ftp'

Net::FTP.open('ftp.ed.ac.uk', "anonymous","aaa@gmail.com" ) do |ftp|
  ftp.passive = true  # default since Ruby 2.3
  ftp.chdir('pub/courses')
  puts ftp.list
  ftp.getbinaryfile("make.notes.tar")
end
