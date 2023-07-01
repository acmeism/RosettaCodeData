require 'find'

Find.find('/your/path') do |f|
   # print file and path to screen if filename ends in ".mp3"
   puts f if f.match(/\.mp3\Z/)
end
