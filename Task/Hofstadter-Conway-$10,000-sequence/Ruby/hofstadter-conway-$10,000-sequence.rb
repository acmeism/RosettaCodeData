class HofstadterConway10000
  def initialize
    @sequence = [nil, 1, 1]
  end

  def [](n)
    raise ArgumentError, "n must be >= 1" if n < 1
    a = @sequence
    a.length.upto(n) {|i| a[i] = a[a[i-1]] + a[i-a[i-1]] }
    a[n]
  end
end

hc = HofstadterConway10000.new

mallows = nil
(1...20).each do |i|
  j = i + 1
  max_n, max_v = -1, -1
  (2**i .. 2**j).each do |n|
    v = hc[n].to_f / n
    max_n, max_v = n, v if v > max_v
    # Mallows number
    mallows = n if v >= 0.55
  end
  puts "maximum between 2^%2d and 2^%2d occurs at%7d: %.8f" % [i, j, max_n, max_v]
end

puts "the mallows number is #{mallows}"
