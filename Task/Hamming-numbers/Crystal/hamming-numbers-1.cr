require "big"

def hamming(limit)
  h = Array.new(limit, 1.to_big_i)     # h = Array.new(limit+1, 1.to_big_i)
  x2, x3, x5 = 2.to_big_i, 3.to_big_i, 5.to_big_i
  i, j, k = 0, 0, 0
  (1...limit).each do |n|              # (1..limit).each do |n|
    h[n] = Math.min(x2, Math.min(x3, x5))
    x2 = 2 * h[i += 1] if x2 == h[n]
    x3 = 3 * h[j += 1] if x3 == h[n]
    x5 = 5 * h[k += 1] if x5 == h[n]
  end
  h[limit - 1]
end

start = Time.monotonic
print "Hamming Number (1..20): "; (1..20).each { |i| print "#{hamming(i)} " }
puts
puts "Hamming Number 1691: #{hamming 1691}"
puts "Hamming Number 1,000,000: #{hamming 1_000_000}"
puts "Elasped Time: #{(Time.monotonic - start).total_seconds} secs"
