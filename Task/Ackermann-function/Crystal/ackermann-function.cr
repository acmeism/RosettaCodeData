def ack(m, n)
  if m == 0
    n + 1
  elsif n == 0
    ack(m-1, 1)
  else
    ack(m-1, ack(m, n-1))
  end
end

#Example:
(0..3).each do |m|
  puts (0..6).map { |n| ack(m, n) }.join(' ')
end
