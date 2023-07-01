-- N-queens puzzle implemented with "Distinct Choices" pattern
-- Sergio Antoy
-- Tue Sep  4 13:16:20 PDT 2001
-- updated: Mon Sep 23 15:22:15 PDT 2002

import Integer

queens x | y =:= permute x & void (capture y) = y  where y free

capture y = let l1,l2,l3,y1,y2 free in
  l1 ++ [y1] ++ l2 ++ [y2] ++ l3 =:= y & abs (y1-y2) =:= length l2 + 1

-- negation as failure (implemented by encapsulated search):
void c = (findall \_->c) =:= []

-- How does this permutation algorithm work?
-- Only the elements [0,1,...,n-1] can be permuted.
-- The reason is that each element is used as an index in a list.
-- A list, called store, of free variables of length n is created.
-- Then, the n iterations described below are executed.
-- At the i-th iteration, an element, say s,
-- of the initial list is non-deterministically selected.
-- This element is used as index in the store.
-- The s-th variable of the store is unified with i.
-- At the end of the iterations, the elements of the store
-- are a permutation of [0,1,...,n-1], i.e., the elements
-- are unique since two iterations cannot select the same index.

permute n = result n
   where result n = if n==0 then [] else pick n store : result (n-1)
         pick i store | store !! k =:= i = k where k = range n
         range n | n > 0 = range (n-1) ! (n-1)
         store = free
-- end
