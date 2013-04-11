-- snipped the items list; same as above
knapsack = foldr addItem (repeat (0,[])) where
	addItem (name,w,v) list = left ++ zipWith max right newlist where
		newlist = map (\(val, names)->(val + v, name:names)) list
		(left,right) = splitAt w list

main = print $ (knapsack inv) !! 400
