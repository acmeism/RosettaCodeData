def sum_proper_divisors (n)
  z = n.class.zero
  (z+1..n//2).sum(z) {|i| n % i == 0 ? i : 0 }
end

labels = %w(abundant perfect deficient)

(1..20_000).tally_by {|i| i <=> sum_proper_divisors(i) }
  .to_a.sort
  .zip(labels)
  .each do |(_, count), label|
  printf "%6d %s\n", count, label
end
