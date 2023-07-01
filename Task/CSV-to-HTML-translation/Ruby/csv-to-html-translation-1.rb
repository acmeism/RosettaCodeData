require 'cgi'

puts '<table summary="csv2html program output">'

def row2html str, wrap = "td"
  "<tr>" +
    str.split(",").map { |cell| "<#{wrap}>#{CGI.escapeHTML cell}</#{wrap}>" }.join +
  "</tr>"
end

puts row2html gets.chomp, "th" if ARGV.delete "header"

while str = gets
  puts row2html str.chomp
end

puts "</table>"
