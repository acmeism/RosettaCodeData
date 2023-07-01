-- find largest left- & right-truncatable primes < 1 million.
-- an initial set of primes (not, at this time, we leave out 2 because
-- we'll automatically skip the even numbers.  No point in doing a needless
-- test each time through
primes = .array~of(3, 5, 7, 11)

-- check all of the odd numbers up to 1,000,000
loop j = 13 by 2 to 1000000
  loop i = 1 to primes~size
      prime = primes[i]
      -- found an even prime divisor
      if j // prime == 0 then iterate j
      -- only check up to the square root
      if prime*prime > j then leave
  end
  -- we only get here if we don't find a divisor
  primes~append(j)
end

-- get a set of the primes that we can test more efficiently
primeSet = .set~of(2)
primeSet~putall(primes)


say 'The last prime is' primes[primes~last] "("primeSet~items 'primes under one million).'
say copies('-',66)

lastLeft = 0

-- we're going to use the array version to do these in order.  We're still
-- missing "2", but that's not going to be the largest
loop prime over primes

    -- values containing 0 can never work
    if prime~pos(0) \= 0 then iterate
    -- now start the truncations, checking against our set of
    -- known primes
    loop i = 1 for prime~length - 1
        subprime = prime~right(i)
        -- not in our known set, this can't work
        if \primeset~hasIndex(subprime) then iterate prime
    end
    -- this, by definition, with be the largest left-trunc prime
    lastLeft = prime
end
-- now look for right-trunc primes
lastRight = 0
loop prime over primes

    -- values containing 0 can never work
    if prime~pos(0) \= 0 then iterate
    -- now start the truncations, checking against our set of
    -- known primes
    loop i = 1 for prime~length - 1
        subprime = prime~left(i)
        -- not in our known set, this can't work
        if \primeset~hasIndex(subprime) then iterate prime
    end
    -- this, by definition, with be the largest left-trunc prime
    lastRight = prime
end

say 'The largest  left-truncatable prime is' lastLeft '(under one million).'
say 'The largest right-truncatable prime is' lastRight '(under one million).'
