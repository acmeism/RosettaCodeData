primesPTDW :: () -> [Int] -- nested filters, no matter how much postponed,
primesPTDW() = -- causes mucho allocation of deferred thunks!
    wheelPrimes ++ _Y ((firstSievePrime :) . sieve cndts) where
  _Y g = g (_Y g)        -- non-sharing multi-stage fixpoint combinator
  cndts = scanl (+) (firstSievePrime + head gaps) (tail $ cycle gaps)
  sieve xs (bp:bps') = after xs where
    q = bp * bp
    after (x:xs') | x >= q = sieve (filter ((> 0) . (`rem` bp)) xs') bps'
                  | otherwise = x : after xs'
