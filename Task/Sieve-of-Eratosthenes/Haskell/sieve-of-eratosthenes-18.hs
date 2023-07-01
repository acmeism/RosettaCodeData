-- Note:  this code segment uses the same wheelGen as the Tree-Folding version...

primesPQWheeled :: () -> [Int]
primesPQWheeled() =
    wheelPrimes ++ map fst (
      _Y (((firstSievePrime, wheel) :) .
            sieve (firstSievePrime + head wheel, tail wheel)
                  emptyPQ (firstSievePrime * firstSievePrime)) )
  where
    _Y g = g (_Y g)        -- non-sharing multi-stage fixpoint combinator OR

    wheel = cycle gaps

    sieve npr@(n,(g:gs')) table q bpprs@(bppr:bpprs')
        | n >= q =
            let (nbp,_) = head bpprs' in let ntbl = insertprime bppr table in
            nbp `seq` ntbl `seq` sieve (n + g, gs') ntbl (nbp * nbp) bpprs'
        | n >= nextComposite = let ntbl = adjust table in
                               ntbl `seq` sieve (n + g, gs') ntbl q bpprs
        | otherwise = npr : sieve (n + g, gs') table q bpprs
      where
        insertprime (p,(pg:pgs')) table =
          let nv = p * (p + pg) in nv `seq` pushPQ nv (map (* p) pgs') table
        nextComposite = case peekMinPQ table of
                          Nothing -> q -- at beginning when queue empty!
                          Just (c, _) -> c
        adjust table
            | c <= n = let ntbl = replaceMinPQ (c + a) as' table
                       in ntbl `seq` adjust ntbl
            | otherwise = table
          where (c, (a:as')) = case peekMinPQ table of Just ct -> ct `seq` ct
