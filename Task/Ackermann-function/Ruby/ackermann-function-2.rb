(0..3).each do |m|
  puts (0..6).map { |n| ack(m, n) }.join(' ')
end
