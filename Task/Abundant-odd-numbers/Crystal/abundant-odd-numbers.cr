def sum_proper_odd_divisors (n)
  √n = Math.isqrt(n)
  z = n.class.zero
  sum = z+1
  (z+3 .. √n).step(2) do |i|
    if n % i == 0
      sum += i + (i == (j = n // i) ? 0 : j)
    end
  end
  sum
end

def abunseq (start=1)
  start += 1 unless start.odd?
  (start..).step(2).each.select {|n| n < sum_proper_odd_divisors(n) }
end

iter = abunseq
puts "First 25:"
iter.first(25).each do |aon|
  printf "%6d  (%d)\n", aon, sum_proper_odd_divisors(aon)
end

n1k = iter.skip(999-25).next
raise "?" if n1k.is_a?(Iterator::Stop)
print "\nThe 1000th: ", n1k, " (", sum_proper_odd_divisors(n1k), ")"

n1b = abunseq(1_000_000_000).next
raise "?" if n1b.is_a?(Iterator::Stop)
print "\nThe first > 1B: ", n1b, " (", sum_proper_odd_divisors(n1b), ")\n"
