n = 0
loop do
  puts "%o" % n
  n += 1
end

# or
for n in 0..Float::INFINITY
  puts n.to_s(8)
end

# or
0.upto(1/0.0) do |n|
  printf "%o\n", n
end

# version 2.1 later
0.step do |n|
  puts format("%o", n)
end
