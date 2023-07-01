require "prime"

class Integer
  def square_free?
    prime_division.none?{|pr, exp| exp > 1}
  end
end

puts (1..145).select(&:square_free?).each_slice(20).map{|a| a.join(" ")}
puts

m = 10**12
puts (m..m+145).select(&:square_free?).each_slice(6).map{|a| a.join(" ")}
puts

markers = [100, 1000, 10_000, 100_000, 1_000_000]
count = 0
(1..1_000_000).each do |n|
  count += 1 if n.square_free?
  puts "#{count} square-frees upto #{n}" if markers.include?(n)
end
