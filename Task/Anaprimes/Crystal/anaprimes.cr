require "bit_array"

def make_sieve (size)
  sieve = BitArray.new size, true
  sieve[0] = sieve[1] = false
  (2..Math.isqrt(size)).each do |i|
    if sieve[i]
      (i*i...size).step(i+i) do |j|
        sieve[j] = false
      end
    end
  end
  sieve
end

struct Int
  def anaclass
    res = Bytes.new(10, 0_u8)
    n = self
    loop do
      n, rem = n.divmod 10
      res[rem] += 1
      return res  if n == 0
    end
  end
end

limit = 1_000_000_000

prime = make_sieve limit

(2..).each.map {|i| 10_i64**i }.each_cons_pair do |from, to|
  break if from >= limit
  groups = (from+1 .. to-1).step(2).each.select {|i| prime[i] }.group_by &.anaclass
  maxsize = groups.max_of {|_, g| g.size }
  largest = groups.values.select {|g| g.size == maxsize }.sort_by &.first
  puts "#{Math.log10(from).to_i+1} digits. #{largest.size} largest group(s) with size #{maxsize}"
  largest.each do |g|
    puts "  min: %d  max: %d" % g.minmax
  end
  puts
end
