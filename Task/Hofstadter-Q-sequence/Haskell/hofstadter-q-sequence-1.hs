qSequence = tail qq where
  qq = 0 : 1 : 1 : map g [3..]
  g n = qq !! (n - qq !! (n-1)) + qq !! (n - qq !! (n-2))

-- Output:
*Main> (take 10 qSequence, qSequence !! (1000-1))
([1,1,2,3,3,4,5,5,6,6],502)
(0.00 secs, 525044 bytes)
