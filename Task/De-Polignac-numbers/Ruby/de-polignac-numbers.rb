require 'prime'

def pow2floor(n)
  n.bit_length-1
end

def polignac?(n)
  (0..pow2floor(n)).none? {|exp| (n-(1 << exp)).prime? }
end

polignacs =  (1..).step(2).lazy.select{|n| polignac?(n)}.first(10000)

puts "first #{n = 50} de Polignac numbers:"
polignacs[0...n].each_slice(10){|s| puts "%5d"*s.size % s}
[1000, 10000].each{|n| puts "\n#{n}: #{polignacs[n-1]}"}
