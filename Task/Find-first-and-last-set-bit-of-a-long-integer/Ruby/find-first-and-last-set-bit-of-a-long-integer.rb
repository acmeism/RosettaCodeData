def msb(x)
  x.bit_length - 1
end

def lsb(x)
  msb(x & -x)
end

6.times do |i|
  x = 42 ** i
  puts "%10d MSB: %2d LSB: %2d" % [x, msb(x), lsb(x)]
end

6.times do |i|
  x = 1302 ** i
  puts "%20d MSB: %2d LSB: %2d" % [x, msb(x), lsb(x)]
end
