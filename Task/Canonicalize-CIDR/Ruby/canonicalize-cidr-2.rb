require "ipaddr"

tests = ["87.70.141.1/22", "36.18.154.103/12", "62.62.197.11/29",
  "67.137.119.181/4", "161.214.74.21/24", "184.232.176.184/18"]

tests.each do |str|
  ia = IPAddr.new(str)
  puts "#{ia}/#{ia.prefix}"
end
