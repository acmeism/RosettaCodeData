require "big"

def farey(n, length = false)
  a = [] of BigRational
  if length
    (n*(n+3))//2 - (2..n).sum{ |k| farey(n//k, true).as(Int32) }
  else
    (1..n).each{ |k| (0..k).each{ |m| a << BigRational.new(m,k) } }; a.uniq.sort
  end
end

puts "Farey sequence for order 1 through 11 (inclusive):"
(1..11).each do |n|
  puts "F(#{n}): 0/1 #{farey(n).as(Array(BigRational))[1..-2].join(" ")} 1/1"
end

puts "Number of fractions in the Farey sequence:"
(100..1000).step(100) do |i|
  puts "F(%4d) =%7d" % [i, farey(i, true)]
end
