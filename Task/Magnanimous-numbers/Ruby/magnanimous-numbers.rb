require "prime"

magnanimouses = Enumerator.new do |y|
  (0..).each {|n| y << n if (1..n.digits.size-1).all? {|k| n.divmod(10**k).sum.prime?} }
end

puts "First 45 magnanimous numbers:"
puts magnanimouses.first(45).join(' ')

puts "\n241st through 250th magnanimous numbers:"
puts magnanimouses.first(250).last(10).join(' ')

puts "\n391st through 400th magnanimous numbers:"
puts magnanimouses.first(400).last(10).join(' ')
