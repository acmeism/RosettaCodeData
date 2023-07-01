fact = 1
e = 2
e0 = 0
n = 2

until (e - e0).abs < Float::EPSILON do
  e0 = e
  fact *= n
  n += 1
  e += 1.0 / fact
end

puts e
