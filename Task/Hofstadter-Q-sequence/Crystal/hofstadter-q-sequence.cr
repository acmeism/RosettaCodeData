class Q
  @@cache = [0, 1, 1]

  def self.[] (n)
    if n >= @@cache.size
      (@@cache.size ... n).each do |i|
        Q[i]
      end
      @@cache << @@cache[n - @@cache[n-1]] + @@cache[n - @@cache[n-2]]
    end
    @@cache[n]
  end
end

print "First 10 terms: "
puts (1..10).map {|i| Q[i] }.join(" ")

puts "1000th term: #{ Q[1000] }"

c = (2..100_000).count {|i| Q[i] < Q[i-1] }

puts "Less than preceding: #{c}"
