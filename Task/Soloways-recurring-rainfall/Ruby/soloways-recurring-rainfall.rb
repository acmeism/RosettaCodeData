QUIT  = 99999
num   = nil
count = 0
avg   = 0.0

loop do
  begin
    print "Enter rainfall int, #{QUIT} to quit: "
    input = gets
    num = Integer(input)
  rescue ArgumentError
    puts "Invalid input #{input}"
    redo
  end
  break if num == QUIT
  count += 1
  inv_count = 1.0/count
  avg = avg + inv_count*num - inv_count*avg
end

puts "#{count} numbers entered, averaging #{average}"
