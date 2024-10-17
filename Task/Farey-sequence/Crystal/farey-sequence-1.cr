require "big"

def farey(n)
    a, b, c, d = 0, 1, 1, n
    fracs = [] of BigRational
    fracs << BigRational.new(0,1)
    while c <= n
        k = (n + b) // d
        a, b, c, d = c, d, k * c - a, k * d - b
        fracs << BigRational.new(a,b)
    end
    fracs.uniq.sort
end

puts "Farey sequence for order 1 through 11 (inclusive):"
(1..11).each do |n|
  puts "F(#{n}): 0/1 #{farey(n)[1..-2].join(" ")} 1/1"
end

puts "Number of fractions in the Farey sequence:"
(100..1000).step(100) do |i|
  puts "F(%4d) =%7d" % [i, farey(i).size]
end
