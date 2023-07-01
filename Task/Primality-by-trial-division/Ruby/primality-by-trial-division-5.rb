require "benchmark/ips"

# the simplest PG primality test using the P3 prime generator
# reduces the number space for primes to 2/6 (33.33%) of all integers

def primep3?(n)                           # P3 Prime Generator primality test
  # P3 = 6*k + {5, 7}                     # P3 primes candidates (pc) sequence
  return n | 1 == 3 if n < 5              # n: 0,1,4|false, 2,3|true
  return false if n.gcd(6) != 1           # 1/3 (2/6) of integers are P3 pc
  p, sqrtn = 5, Integer.sqrt(n)           # first P3 sequence value
  until p > sqrtn
    return false if n % p == 0 || n % (p + 2) == 0  # if n is composite
    p += 6      # first prime candidate for next kth residues group
  end
  true
end

# PG primality test using the P5 prime generator
# reduces the number space for primes to 8/30 (26.67%) of all integers

def primep5?(n)                           # P5 Prime Generator primality test
   # P5 = 30*k + {7,11,13,17,19,23,29,31} # P5 primes candidates sequence
   return [2, 3, 5].include?(n) if n < 7  # for small and negative values
   return false if n.gcd(30) != 1         # 4/15 (8/30) of integers are P5 pc
   p, sqrtn = 7, Integer.sqrt(n)          # first P5 sequence value
   until p > sqrtn
     return false if                      # if n is composite
       n % (p)    == 0 || n % (p+4)  == 0 || n % (p+6)  == 0 || n % (p+10) == 0 ||
       n % (p+12) == 0 || n % (p+16) == 0 || n % (p+22) == 0 || n % (p+24) == 0
       p += 30  # first prime candidate for next kth residues group
   end
   true
end

# PG primality test using the P7 prime generator
# reduces the number space for primes to 48/210 (22.86%) of all integers

def primep7?(n)
  # P7 = 210*k + {11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,
  #      89,97,101,103,107,109,113,121,127,131,137,139,143,149,151,157,163,
  #      167,169,173,179,181,187,191,193,197,199,209,211}
  return [2, 3, 5, 7].include?(n) if n < 11
  return false if n.gcd(210) != 1         # 8/35 (48/210) of integers are P7 pc
  p, sqrtn = 11, Integer.sqrt(n)          # first P7 sequence value
  until p > sqrtn
    return false if
      n % (p)     == 0 || n % (p+2)   == 0 || n % (p+6)   == 0 || n % (p+8)   == 0 ||
      n % (p+12)  == 0 || n % (p+18)  == 0 || n % (p+20)  == 0 || n % (p+26)  == 0 ||
      n % (p+30)  == 0 || n % (p+32)  == 0 || n % (p+36)  == 0 || n % (p+42)  == 0 ||
      n % (p+48)  == 0 || n % (p+50)  == 0 || n % (p+56)  == 0 || n % (p+60)  == 0 ||
      n % (p+62)  == 0 || n % (p+68)  == 0 || n % (p+72)  == 0 || n % (p+78)  == 0 ||
      n % (p+86)  == 0 || n % (p+90)  == 0 || n % (p+92)  == 0 || n % (p+96)  == 0 ||
      n % (p+98)  == 0 || n % (p+102) == 0 || n % (p+110) == 0 || n % (p+116) == 0 ||
      n % (p+120) == 0 || n % (p+126) == 0 || n % (p+128) == 0 || n % (p+132) == 0 ||
      n % (p+138) == 0 || n % (p+140) == 0 || n % (p+146) == 0 || n % (p+152) == 0 ||
      n % (p+156) == 0 || n % (p+158) == 0 || n % (p+162) == 0 || n % (p+168) == 0 ||
      n % (p+170) == 0 || n % (p+176) == 0 || n % (p+180) == 0 || n % (p+182) == 0 ||
      n % (p+186) == 0 || n % (p+188) == 0 || n % (p+198) == 0 || n % (p+200) == 0
    p += 210    # first prime candidate for next  kth residues group
  end
  true
end

# Benchmarks to test for various size primes

p = 541
Benchmark.ips do |b|
    print "\np = #{p}"
    b.report("primep3?") { primep3?(p) }
    b.report("primep5?") { primep5?(p) }
    b.report("primep7?") { primep7?(p) }
    b.compare!
    puts
end

p = 1000003
Benchmark.ips do |b|
    print "\np = #{p}"
    b.report("primep3?") { primep3?(p) }
    b.report("primep5?") { primep5?(p) }
    b.report("primep7?") { primep7?(p) }
    b.compare!
    puts
end

p = 4294967291            # largest prime < 2**32
Benchmark.ips do |b|
    print "\np = #{p}"
    b.report("primep3?") { primep3?(p) }
    b.report("primep5?") { primep5?(p) }
    b.report("primep7?") { primep7?(p) }
    b.compare!
    puts
end

p = (10 ** 16) * 2 + 3
Benchmark.ips do |b|
    print "\np = #{p}"
    b.report("primep3?") { primep3?(p) }
    b.report("primep5?") { primep5?(p) }
    b.report("primep7?") { primep7?(p) }
    b.compare!
    puts
end
