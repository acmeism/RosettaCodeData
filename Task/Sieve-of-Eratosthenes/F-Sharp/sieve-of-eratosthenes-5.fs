let primes limit =
  let lmtb,lmtbsqrt = (limit - 3u) / 2u, (uint32 (sqrt (double limit)) - 3u) / 2u
  let buf = System.Collections.BitArray(int lmtb + 1, true)
  let rec culltest i = if i <= lmtbsqrt then
                         let p = i + i + 3u in let s = p * (i + 1u) + i in
                         let rec cullp c = if c <= lmtb then buf.[int c] <- false; cullp (c + p)
                         (if buf.[int i] then cullp s); culltest (i + 1u) in culltest 0u
  seq {yield 2u; for i = 0u to lmtb do if buf.[int i] then yield i + i + 3u }
