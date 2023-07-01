require 'prime'

emirp = Enumerator.new do |y|
  Prime.each do |prime|
    rev = prime.to_s.reverse.to_i
    y << prime  if rev.prime? and rev != prime
  end
end

puts "First 20 emirps:", emirp.first(20).join(" ")
puts "Emirps between 7,700 and 8,000:"
emirp.with_index(1) do |prime,i|
  print "#{prime} "  if (7700..8000).cover?(prime)
  if i==10000
    puts "", "10,000th emirp:", prime
    break
  end
end
