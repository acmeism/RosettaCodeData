(defn primes-before
  "Gives all the primes < limit"
  [limit]
  (assert (int? limit))
  # Janet has a buffer type (mutable string) which has easy methods for use as bitset
  (def buf-size (math/ceil (/ limit 8)))
  (def is-prime (buffer/new-filled buf-size (bnot 0)))
  (print "Size" buf-size "is-prime: " is-prime)
  (buffer/bit-clear is-prime 0)
  (buffer/bit-clear is-prime 1)
  (for n 0 (math/ceil (math/sqrt limit))
    (if (buffer/bit is-prime n) (loop [i :range-to [(* n n) limit n]]
      (buffer/bit-clear is-prime i))))
  (def res @[]) # Result: Mutable array
  (for i 0 limit
    (if (buffer/bit is-prime i)
      (array/push res i)))
  (def res (array/new limit))
  (for i 0 limit
    (if (buffer/bit is-prime i)
      (array/push res i)))
  res)
