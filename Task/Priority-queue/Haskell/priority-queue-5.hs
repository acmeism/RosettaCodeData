data PriorityQ k v = Mt
                     | Br !k v !(PriorityQ k v) !(PriorityQ k v)
  deriving (Eq, Ord, Read, Show)

emptyPQ :: PriorityQ k v
emptyPQ = Mt

isEmptyPQ :: PriorityQ k v -> Bool
isEmptyPQ Mt = True
isEmptyPQ _  = False

-- The size function isn't from the ML code, but an implementation was
-- suggested by Bertram Felgenhauer on Haskell Cafe, so it is included.

-- Return number of elements in the priority queue.
-- /O(log(n)^2)/
sizePQ :: PriorityQ k v -> Int
sizePQ Mt = 0
sizePQ (Br _ _ pl pr) = 2 * n + rest n pl pr where
  n = sizePQ pr
  -- rest n p q, where n = sizePQ q, and sizePQ p - sizePQ q = 0 or 1
  -- returns 1 + sizePQ p - sizePQ q.
  rest :: Int -> PriorityQ k v -> PriorityQ k v -> Int
  rest 0 Mt _ = 1
  rest 0 _  _ = 2
  rest n (Br _ _ ll lr) (Br _ _ rl rr) = case r of
      0 -> rest d ll rl -- subtree sizes: (d or d+1), d; d, d
      1 -> rest d lr rr -- subtree sizes: d+1, (d or d+1); d+1, d
    where m1 = n - 1
          d = m1 `shiftR` 1
          r = m1 .&. 1

peekMinPQ :: PriorityQ k v -> Maybe (k, v)
peekMinPQ Mt           = Nothing
peekMinPQ (Br k v _ _) = Just (k, v)

pushPQ :: Ord k => k -> v -> PriorityQ k v -> PriorityQ k v
pushPQ wk wv Mt           = Br wk wv Mt Mt
pushPQ wk wv (Br vk vv pl pr)
             | wk <= vk   = Br wk wv (pushPQ vk vv pr) pl
             | otherwise  = Br vk vv (pushPQ wk wv pr) pl

siftdown :: Ord k => k -> v -> PriorityQ k v -> PriorityQ k v -> PriorityQ k v
siftdown wk wv Mt _          = Br wk wv Mt Mt
siftdown wk wv (pl @ (Br vk vv _ _)) Mt
    | wk <= vk               = Br wk wv pl Mt
    | otherwise              = Br vk vv (Br wk wv Mt Mt) Mt
siftdown wk wv (pl @ (Br vkl vvl pll plr)) (pr @ (Br vkr vvr prl prr))
    | wk <= vkl && wk <= vkr = Br wk wv pl pr
    | vkl <= vkr             = Br vkl vvl (siftdown wk wv pll plr) pr
    | otherwise              = Br vkr vvr pl (siftdown wk wv prl prr)

replaceMinPQ :: Ord k => k -> v -> PriorityQ k v -> PriorityQ k v
replaceMinPQ wk wv Mt             = Mt
replaceMinPQ wk wv (Br _ _ pl pr) = siftdown wk wv pl pr

deleteMinPQ :: (Ord k) =>  PriorityQ k v -> PriorityQ k v
deleteMinPQ Mt             = Mt
deleteMinPQ (Br _ _ pr Mt) = pr
deleteMinPQ (Br _ _ pl pr) = let (k, v, npl) = leftrem pl in
                             siftdown k v pr npl where
  leftrem (Br k v Mt Mt)             = (k, v, Mt)
  leftrem (Br vk vv (Br k v _ _) Mt) = (k, v, Br vk vv Mt Mt)
  leftrem (Br vk vv pl pr)           = let (k, v, npl) = leftrem pl in
                                       (k, v, Br vk vv pr npl)

-- the following function has been added to the ML code to apply a function
--   to all the entries in the queue and reheapify in O(n) time
adjustPQ :: (Ord k) => (k -> v -> (k, v)) -> PriorityQ k v -> PriorityQ k v
adjustPQ f pq = adjust pq where -- applies function to every element and reheapifies
  adjust Mt               = Mt
  adjust (Br vk vv pl pr) = let (k, v) = f vk vv in
                            siftdown k v (adjust pl) (adjust pr)

fromListPQ :: (Ord k) => [(k, v)] -> PriorityQ k v
-- fromListPQ = foldl (flip pushPQ) Mt -- O(n log n) time; slow
fromListPQ [] = Mt -- O(n) time using adjust-from-bottom which is O(n)
fromListPQ xs = let (pq, _) = build (length xs) xs in pq where
  build 0 xs             = (Mt, xs)
  build lvl ((k, v):xs') = let (pl, xrl) = build (lvl `shiftR` 1) xs'
                               (pr, xrr) = build ((lvl - 1) `shiftR` 1) xrl in
                           (siftdown k v pl pr, xrr)

-- the following function has been added to merge two queues in O(m + n) time
--   where m and n are the sizes of the two queues
mergePQ :: (Ord k) => PriorityQ k v -> PriorityQ k v -> PriorityQ k v
mergePQ pq1 Mt = pq1 -- from concatenated "dumb" list
mergePQ Mt pq2 = pq2 -- in O(m + n) time where m,n are sizes pq1,pq2
mergePQ pq1 pq2 = fromListPQ (zipper pq1 $ zipper pq2 []) where
  zipper (Br wk wv Mt _) appndlst  = (wk, wv) : appndlst
  zipper (Br wk wv pl Mt) appndlst = (wk, wv) : zipper pl appndlst
  zipper (Br wk wv pl pr) appndlst = (wk, wv) : zipper pl (zipper pr appndlst)

popMinPQ :: (Ord k) => PriorityQ k v -> Maybe ((k, v), PriorityQ k v)
popMinPQ pq = case peekMinPQ pq of
                Nothing -> Nothing
                Just kv -> Just (kv, deleteMinPQ pq)

toListPQ :: (Ord k) => PriorityQ k v -> [(k, v)]
toListPQ Mt                  = [] -- unfoldr popMinPQ
toListPQ pq @ (Br vk vv _ _) = (vk, vv) : (toListPQ $ deleteMinPQ pq)

sortPQ :: (Ord k) => [(k, v)] -> [(k, v)]
sortPQ ls = toListPQ $ fromListPQ ls
