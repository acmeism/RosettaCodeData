primesPQx :: () -> [Int]
primesPQx() = 2 : _Y ((3 :) . sieve 5 emptyPQ 9) -- initBasePrms
  where
    _Y g = g (_Y g)        -- non-sharing multi-stage fixpoint combinator OR

    sieve n table q bps@(bp:bps')
        | n >= q = let nbp = head bps' in let ntbl = insertprime bp table in
                   ntbl `seq` sieve (n + 2) ntbl (nbp * nbp) bps'
        | n >= nextComposite = let ntbl = adjust table in
                               ntbl `seq` sieve (n + 2) ntbl q bps
        | otherwise = n : sieve (n + 2) table q bps
      where
        insertprime p table = let adv = 2 * p in let nv = p * p + adv
                              in nv `seq` pushPQ nv adv table
        nextComposite = case peekMinPQ table of
                          Nothing -> q -- at beginning when queue empty!
                          Just (c, _) -> c
        adjust table
            | c <= n = let ntbl = replaceMinPQ (c + adv) adv table
                       in ntbl `seq` adjust ntbl
            | otherwise = table
          where (c, adv) = case peekMinPQ table of Just ct -> ct `seq` ct
