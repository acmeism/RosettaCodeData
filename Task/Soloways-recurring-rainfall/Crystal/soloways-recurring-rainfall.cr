require "big"

sum = 0.to_big_i
cnt = 0

puts "At each prompt enter an integer between -2³¹ and 2³¹-1"
puts "and I'll tell you the cumulative average. Enter 99999 to quit."

loop do
  print "> "; STDOUT.flush
  begin
    num = (gets || break).to_i
    break if num == 99999
    sum += num
    cnt += 1
    puts "CA=#{sum / cnt}"
  rescue
    puts "invalid input ignored"
  end
end
