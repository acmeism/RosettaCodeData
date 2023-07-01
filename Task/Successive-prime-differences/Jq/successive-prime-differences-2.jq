[pow(10;6) | primes] as $p1e6
| ([2], [1], [2,2], [2,4], [4,2], [6,4,2]) as $d
| ("\nFor deltas = \($d):", report_first_last_count(filter_differences($p1e6[]; $d ) ) )
