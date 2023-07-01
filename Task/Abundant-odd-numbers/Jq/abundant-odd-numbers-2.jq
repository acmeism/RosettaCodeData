( ["n", "sum of divisors"],
  limit(25; abundant_odd_numbers)),
  [],
(["The 1000th abundant odd number and corresponding sum of divisors:"]
 + nth(999; abundant_odd_numbers))
| @tsv
