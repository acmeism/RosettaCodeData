data MinHeap a = Nil | MinHeap { v::a, cnt::Int, l::MinHeap a, r::MinHeap a }
	deriving (Show, Eq)

hPush :: (Ord a) => a -> MinHeap a -> MinHeap a
hPush x Nil = MinHeap {v = x, cnt = 1, l = Nil, r = Nil}
hPush x h = if x < vv -- insert element, try to keep the tree balanced
	then if hLength (l h) <= hLength (r h)
		then MinHeap { v=x, cnt=cc, l=hPush vv ll, r=rr }
		else MinHeap { v=x, cnt=cc, l=ll, r=hPush vv rr }
	else if hLength (l h) <= hLength (r h)
		then MinHeap { v=vv, cnt=cc, l=hPush x ll, r=rr }
		else MinHeap { v=vv, cnt=cc, l=ll, r=hPush x rr }
	where	(vv, cc, ll, rr) = (v h, 1 + cnt h, l h, r h)

hPop :: (Ord a) => MinHeap a -> (a, MinHeap a)
hPop h = (v h, pq) where -- just pop, heed not the tree balance
	pq	| l h == Nil = r h
		| r h == Nil = l h
		| v (l h) <= v (r h) = let (vv,hh) = hPop (l h) in
			MinHeap {v = vv, cnt = hLength hh + hLength (r h),
				l = hh, r = r h}
		| otherwise = let (vv,hh) = hPop (r h) in
			MinHeap {v = vv, cnt = hLength hh + hLength (l h),
				l = l h, r = hh}

hLength :: (Ord a) => MinHeap a -> Int
hLength Nil = 0
hLength h = cnt h

hFromList :: (Ord a) => [a] -> MinHeap a
hFromList = foldl (flip hPush) Nil

hToList :: (Ord a) => MinHeap a -> [a]
hToList = unfoldr f where
  f Nil = Nothing
  f h = Just $ hPop h

main = mapM_ print $ hToList $ hFromList [
	(3, "Clear drains"),
	(4, "Feed cat"),
	(5, "Make tea"),
	(1, "Solve RC tasks"),
	(2, "Tax return")]
