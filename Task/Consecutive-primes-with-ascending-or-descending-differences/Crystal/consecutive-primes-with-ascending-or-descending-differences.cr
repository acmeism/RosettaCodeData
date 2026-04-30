struct Int
  # from [[Primality by trial division#Crystal]], slightly adjusted
  def prime?
    n = self.abs
    return n == 2 || n == 3 || n == 5 if n < 7
    return false if n.gcd(30) != 1
    p = typeof(n).new(7)
    √n = Math.isqrt(n)
    until p > √n
      return false if
        n % (p)    == 0 || n % (p+4)  == 0 || n % (p+6)  == 0 || n % (p+10) == 0 ||
        n % (p+12) == 0 || n % (p+16) == 0 || n % (p+22) == 0 || n % (p+24) == 0
      p += 30
    end
    true
  end
end

def longest_ascending_differences (seq)
  diffs = seq.cons_pair.map {|a, b| {a, b, b-a} }
  diffs.chunk_while {|(_, _, diff1), (_, _, diff2)| diff2 > diff1 }
    .max_by {|chunk| chunk.size }
    .each.with_index.flat_map {|(a, b, _), i| i == 0 ? [a, b] : b }
    .to_a
end

def primes1M
  (1..1_000_000).each.select &.prime?
end

p longest_ascending_differences(primes1M)
p longest_ascending_differences(primes1M.map &.*(-1)).map &.*(-1)
