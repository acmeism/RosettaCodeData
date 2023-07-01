data PriorityQ k v = Mt
                     | Br !k v !(PriorityQ k v) !(PriorityQ k v)
  deriving (Eq, Ord, Read, Show)

emptyPQ :: PriorityQ k v
emptyPQ = Mt

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
