data MinHeap kv = MinHeapEmpty
                  | MinHeapLeaf !kv
                  | MinHeapNode !kv {-# UNPACK #-} !Int !(MinHeap a) !(MinHeap a)
  deriving (Show, Eq)

emptyPQ :: MinHeap kv
emptyPQ = MinHeapEmpty

isEmptyPQ :: PriorityQ kv -> Bool
isEmptyPQ Mt = True
isEmptyPQ _  = False

sizePQ :: (Ord kv) => MinHeap kv -> Int
sizePQ MinHeapEmpty = 0
sizePQ (MinHeapLeaf _) = 1
sizePQ (MinHeapNode _ cnt _ _) = cnt

peekMinPQ :: MinHeap kv -> Maybe kv
peekMinPQ MinHeapEmpty = Nothing
peekMinPQ (MinHeapLeaf v) = Just v
peekMinPQ (MinHeapNode v _ _ _) = Just v

pushPQ :: (Ord kv) => kv -> MinHeap kv -> MinHeap kv
pushPQ kv pq = insert kv 0 pq where -- insert element, keeping the tree balanced
  insert kv _ MinHeapEmpty = MinHeapLeaf kv
  insert kv _ (MinHeapLeaf vv) = if kv <= vv
      then MinHeapNode kv 2 (MinHeapLeaf vv) MinHeapEmpty
      else MinHeapNode vv 2 (MinHeapLeaf kv) MinHeapEmpty
  insert kv msk (MinHeapNode vv cc ll rr) = if kv <= vv
      then if nmsk >= 0
        then MinHeapNode kv nc (insert vv nmsk ll) rr
        else MinHeapNode kv nc ll (insert vv nmsk rr)
      else if nmsk >= 0
        then MinHeapNode vv nc (insert kv nmsk ll) rr
        else MinHeapNode vv nc ll (insert kv nmsk rr)
    where nc = cc + 1
          nmsk = if msk /= 0 then msk `shiftL` 1 -- walk path to next
                 else let s = floor $ (log $ fromIntegral nc) / log 2 in
                      (nc `shiftL` ((finiteBitSize cc) - s)) .|. 1 --never 0 again

siftdown :: (Ord kv) => kv -> Int -> MinHeap kv -> MinHeap kv -> MinHeap kv
siftdown kv cnt lft rght = replace cnt lft rght where
  replace cc ll rr = case rr of -- adj to put kv in current left/right
    MinHeapEmpty -> -- means left is a MinHeapLeaf
      case ll of { (MinHeapLeaf vl) ->
        if kv <= vl
          then MinHeapNode kv 2 ll MinHeapEmpty
          else MinHeapNode vl 2 (MinHeapLeaf kv) MinHeapEmpty }
    MinHeapLeaf vr ->
      case ll of
        MinHeapLeaf vl -> if vl <= vr
          then if kv <= vl then MinHeapNode kv cc ll rr
               else MinHeapNode vl cc (MinHeapLeaf kv) rr
          else if kv <= vr then MinHeapNode kv cc ll rr
               else MinHeapNode vr cc ll (MinHeapLeaf kv)
        MinHeapNode vl ccl lll rrl -> if vl <= vr
          then if kv <= vl then MinHeapNode kv cc ll rr
               else MinHeapNode vl cc (replace ccl lll rrl) rr
          else if kv <= vr then MinHeapNode kv cc ll rr
               else MinHeapNode vr cc ll (MinHeapLeaf kv)
    MinHeapNode vr ccr llr rrr -> case ll of
      (MinHeapNode vl ccl lll rrl) -> -- right is node, so is left
        if vl <= vr then
          if kv <= vl then MinHeapNode kv cc ll rr
          else MinHeapNode vl cc (replace ccl lll rrl) rr
        else if kv <= vr then MinHeapNode kv cc ll rr
             else MinHeapNode vr cc ll (replace ccr llr rrr)

replaceMinPQ :: (Ord kv) => a -> MinHeap kv -> MinHeap kv
replaceMinPQ _ MinHeapEmpty = MinHeapEmpty
replaceMinPQ kv (MinHeapLeaf _) = MinHeapLeaf kv
replaceMinPQ kv (MinHeapNode _ cc ll rr) = siftdown kv cc ll rr where

deleteMinPQ :: (Ord kv) => MinHeap kv -> MinHeap kv
deleteMinPQ MinHeapEmpty = MinHeapEmpty -- remove min keeping tree balanced
deleteMinPQ pq = let (dkv, npq) = delete 0 pq in
                 replaceMinPQ dkv npq where
  delete _ (MinHeapLeaf vv) = (vv, MinHeapEmpty)
  delete msk (MinHeapNode vv cc ll rr) =
      if rr == MinHeapEmpty -- means left is MinHeapLeaf
        then case ll of (MinHeapLeaf vl) -> (vl, MinHeapLeaf vv)
      else if nmsk >= 0 -- means only deal with left
             then let (dv, npq) = delete nmsk ll in
                  (dv, MinHeapNode vv (cc - 1) npq rr)
             else let (dv, npq) = delete nmsk rr in
                  (dv, MinHeapNode vv (cc - 1) ll npq)
    where nmsk = if msk /= 0 then msk `shiftL` 1 -- walk path to last
                 else let s = floor $ (log $ fromIntegral cc) / log 2 in
                      (cc `shiftL` ((finiteBitSize cc) - s)) .|. 1 --never 0 again

adjustPQ :: (Ord kv) => (kv -> kv) -> MinHeap kv -> MinHeap kv
adjustPQ f pq = adjust pq where -- applies function to every element and reheapifies
  adjust MinHeapEmpty = MinHeapEmpty
  adjust (MinHeapLeaf v) = MinHeapLeaf (f v)
  adjust (MinHeapNode vv cc ll rr) = siftdown (f vv) cc (adjust ll) (adjust rr)

fromListPQ :: (Ord kv) => [kv] -> MinHeap kv
-- fromListPQ = foldl (flip pushPQ) MinHeapEmpty -- O(n log n) time; slow
fromListPQ [] = MinHeapEmpty -- O(n) time using "adjust id" which is O(n)
fromListPQ xs = let (_, pq) = build 1 xs in pq where
  sz = length xs
  szd2 = sz `div` 2
  build _ [] = ([], MinHeapEmpty)
  build lvl (x:xs') = if lvl > szd2 then (xs', MinHeapLeaf x)
                      else let nlvl = lvl + lvl in
                           let (xrl, pql) = build nlvl xs' in
                           let (xrr, pqr) = if nlvl >= sz
                                 then (xrl, MinHeapEmpty) -- no right leaf
                                 else build (nlvl + 1) xrl in
                           let cnt = sizePQ pql + sizePQ pqr + 1 in
                           (xrr, siftdown x cnt pql pqr)

popMinPQ :: (Ord kv) => MinHeap kv -> Maybe (kv, MinHeap kv)
popMinPQ pq = case peekMinPQ pq of
                Nothing -> Nothing
                Just v -> Just (v, deleteMinPQ pq)

toListPQ :: (Ord kv) => MinHeap kv -> [kv]
toListPQ = unfoldr f where
  f MinHeapEmpty = Nothing
  f pq = popMinPQ pq

sortPQ :: (Ord kv) => [kv] -> [kv]
sortPQ ls = toListPQ $ fromListPQ ls
