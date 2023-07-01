1.upto 100 do |n|
  r = ''
  r << 'Fizz' if n % 3 == 0
  r << 'Buzz' if n % 5 == 0
  r << n.to_s if r.empty?
  puts r
end
