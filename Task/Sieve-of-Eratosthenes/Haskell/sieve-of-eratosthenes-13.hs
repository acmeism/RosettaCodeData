primesPQx :: () -> [Int]
primesPQx() = 2 : _Y ((3 :) . sieve 5 emptyPQ 9) -- initBasePrms
  where
    _Y g = g (_Y g)        -- non-sharing multi-stage fixpoint combinator OR
--  initBasePrms = 3 : sieve 5 emptyPQ 9 initBasePrms -- single stage
    insertprime p table = let adv = 2 * p in let nv = p * p + adv in
                          nv `seq` pushPQ nv adv table
    sieve n table q bps@(bp:bps')
        | n >= q = let nbp = head bps' in
                   sieve (n + 2) (insertprime bp table) (nbp * nbp) bps'
        | n >= nextComposite = sieve (n + 2) (adjust table) q bps
        | otherwise = n : sieve (n + 2) table q bps
      where
        nextComposite = case peekMinPQ table of
                          Nothing -> q -- at beginning when queue empty
                          Just (c, _) -> c
        adjust table
            | c <= n = let nc = c + adv in
                       nc `seq` adjust (replaceMinPQ nc adv table)
            | otherwise = table
          where (c, adv) = case peekMinPQ table of
                             Just ct -> ct
