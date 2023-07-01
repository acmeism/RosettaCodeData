require 'polynomial'

def x_minus_1_to_the(p)
  return Polynomial.new(-1,1)**p
end

def prime?(p)
  return false if p < 2
  (x_minus_1_to_the(p) - Polynomial.from_string("x**#{p}-1")).coefs.all?{|n| n%p==0}
end

8.times do |n|
  # the default Polynomial#to_s would be OK here; the substitutions just make the
  # output match the other version below.
  puts "(x-1)^#{n} = #{x_minus_1_to_the(n).to_s.gsub(/\*\*/,'^').gsub(/\*/,'')}"
end

puts "\nPrimes below 50:", 50.times.select {|n| prime? n}.join(',')
