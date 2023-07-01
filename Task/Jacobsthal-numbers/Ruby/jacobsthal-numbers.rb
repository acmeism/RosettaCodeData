require 'prime'

def jacobsthal(n) = (2**n + n[0])/3
def jacobsthal_lucas(n) = 2**n + (-1)**n
def jacobsthal_oblong(n) = jacobsthal(n) * jacobsthal(n+1)

puts "First 30 Jacobsthal numbers:"
puts (0..29).map{|n| jacobsthal(n) }.join(" ")

puts "\nFirst 30 Jacobsthal-Lucas numbers: "
puts (0..29).map{|n| jacobsthal_lucas(n) }.join(" ")

puts "\nFirst 20 Jacobsthal-Oblong numbers: "
puts (0..19).map{|n| jacobsthal_oblong(n) }.join(" ")

puts "\nFirst 10 prime Jacobsthal numbers: "
res = (0..).lazy.filter_map do |i|
  j = jacobsthal(i)
  j if j.prime?
end
puts res.take(10).force.join(" ")
