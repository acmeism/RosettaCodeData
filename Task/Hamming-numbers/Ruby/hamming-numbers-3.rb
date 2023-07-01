def hamming(limit)
  h = Array.new(limit, 1)
  x2, x3, x5 = 2, 3, 5
  i, j, k = 0, 0, 0
  (1...limit).each do |n|
    # h[n] = [x2, [x3, x5].min].min    # not as fast on all VMs
    h[n] = (x3 < x5 ? (x2 < x3 ? x2 : x3) : (x2 < x5 ? x2 : x5))
    x2 = 2 * h[i += 1] if x2 == h[n]
    x3 = 3 * h[j += 1] if x3 == h[n]
    x5 = 5 * h[k += 1] if x5 == h[n]
  end
  h[limit - 1]
end

start = Time.new
print "Hamming Number (1..20): "; (1..20).each { |i| print "#{hamming(i)} " }
puts
puts "Hamming Number 1691: #{hamming 1691}"
puts "Hamming Number 1,000,000: #{hamming 1_000_000}"
puts "Elasped Time: #{Time.new - start} secs"
