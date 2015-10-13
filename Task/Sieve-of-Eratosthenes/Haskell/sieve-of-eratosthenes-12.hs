-- (c) 2006-2007 Melissa O'Neill.  Code may be used freely so long as
-- this copyright message is retained and changed versions of the file
-- are clearly marked.
--   the only changes are the names of the called PQ functions and the
--   included processing for the result of the peek function being a maybe tuple.

primesPQ() = 2 : sieve [3,5..]
  where
    sieve [] = []
    sieve (x:xs) = x : sieve' xs (insertprime x xs emptyPQ)
      where
        insertprime p xs table = pushPQ (p*p) (map (* p) xs) table
        sieve' [] table = []
        sieve' (x:xs) table
            | nextComposite <= x = sieve' xs (adjust table)
            | otherwise = x : sieve' xs (insertprime x xs table)
          where
            nextComposite = case peekMinPQ table of
                              Just (c, _) -> c
            adjust table
                | n <= x = adjust (replaceMinPQ n' ns table)
                | otherwise = table
              where (n, n':ns) = case peekMinPQ table of
                                   Just tpl -> tpl
