import Data.Array

-- snipped the item list; use the one from above
knapsack items cap = (solu items) ! cap where
	solu = foldr f (listArray (0,cap) (repeat (0,[])))
	f (name,w,v,cnt) ss = listArray (0,cap) $ map optimal [0..] where
		optimal ww = maximum $ (ss!ww):[prepend (v*i,(name,i)) (ss!(ww - i*w))
					| i <- [1..cnt], i*w < ww]
		prepend (x,n) (y,s) = (x+y,n:s)

main = do print $ knapsack inv 400
