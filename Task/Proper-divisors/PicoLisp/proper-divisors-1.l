# Generate all proper divisors.
(de propdiv (N)
   (head -1 (filter
      '((X) (=0 (% N X)))
      (range 1 N) )) )

# Obtaining the values from 1 to 10 inclusive.
(mapcar propdiv (range 1 10))
# Output:
# (NIL (1) (1) (1 2) (1) (1 2 3) (1) (1 2 4) (1 3) (1 2 5))
