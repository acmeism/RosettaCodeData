require 'prime'

def int_from_digits(ar, base=10)
  # expects array from digits method, which takes a base as argument and gives least significant digit first.
  raise ArgumentError, "#{ar.max} not valid in base #{base}. " if ar.max > base-1
  ar.each_with_index.sum {|d, i| d*base**i }
end

limit = 2500
a121719 = (2..limit).lazy.select do |n|
  next false if (n < 10 && n.prime?)
  digits = n.digits
  from = digits.max + 1
  (from..n).none?{|base| int_from_digits(digits, base).prime? }
end

n = 50
puts "First #{n} pan-base composites:"
a121719.take(n).each_slice(10){|s| puts "%4s"*s.size % s}

n = 20
puts "\nFirst #{n} odd pan-base composites:"
a121719.select(&:odd?).take(n).each_slice(10){|s| puts "%4s"*s.size % s }

tally = a121719.map(&:odd?).tally
total = tally.values.sum
puts "\nCount of pan-base composites up to and including #{limit}: #{total}"
puts "Number of odds  is #{tally[true ]}, proportion  #{tally[true ].fdiv(total) }%"
puts "Number of evens is #{tally[false]}, proportion  #{tally[false].fdiv(total) }%"
