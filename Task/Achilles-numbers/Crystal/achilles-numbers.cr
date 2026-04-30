struct Int
  def totient
    n = self
    return 0 if n < 1
    tot = n
    i = typeof(n).new(2)
    while i*i <= n
      if n % i == 0
        while n % i == 0
          n //= i
        end
        tot -= tot // i
      end
      if i == 2; i = 1 end
      i += 2
    end
    if n > 1
      tot -= tot // n
    end
    tot
  end
end

def get_perfect_powers (max_exp)
  upper = 10_u64 ** max_exp
  pps = Set(UInt64).new
  (2_u64 .. Math.isqrt(upper)).each do |i|
    p = i
    while (p *= i) < upper
      pps << p
    end
  end
  pps
end

def get_achilles (min_exp, max_exp, pps)
  lower = 10_u64 ** min_exp
  upper = 10_u64 ** max_exp
  achilles = Set(UInt64).new
  (1_u64 .. Math.cbrt(upper).to_u64).each do |b|
    b3 = b * b * b
    (1_u64 .. Math.isqrt(upper)).each do |a|
      p = b3 * a * a
      break if p >= upper
      if p >= lower
        achilles << p unless p.in? pps
      end
    end
  end
  achilles
end

def tprint (fmt, seq, row_sz)
  seq.in_slices_of(row_sz).each do |slice|
    puts slice.map {|elt| fmt % { elt } }.join(" ")
  end
end

max_digits = 12
pps = get_perfect_powers(max_digits)

achilles_set = get_achilles(1, 5, pps)
achilles = achilles_set.to_a.sort!

puts "First 50 Achilles numbers:"
tprint("%4d", achilles.first(50), 10)

puts "\nFirst 30 strong Achilles numbers:"
strong_achilles = [] of UInt64
count = 0
n = 0
while count < 30
  tot = achilles[n].totient
  if tot.in? achilles_set
    strong_achilles << achilles[n]
    count += 1
  end
  n += 1
end
tprint("%5d", strong_achilles, 10)

puts "\nNumber of Achilles numbers with:"
(2..max_digits).each do |d|
  ac = get_achilles(d-1, d, pps).size
  puts "%2d digits: %d" % { d, ac }
end
