def farey(n, length=false)
  if length
    (n*(n+3))/2 - (2..n).sum{|k| farey(n/k, true)}
  else
    (1..n).each_with_object([]){|k,a|(0..k).each{|m|a << Rational(m,k)}}.uniq.sort
  end
end

puts 'Farey sequence for order 1 through 11 (inclusive):'
for n in 1..11
  puts "F(#{n}): " + farey(n).join(", ")
end
puts 'Number of fractions in the Farey sequence:'
for i in (100..1000).step(100)
  puts "F(%4d) =%7d" % [i, farey(i, true)]
end
