inv = [("map",9,150), ("compass",13,35), ("water",153,200), ("sandwich",50,160),
       ("glucose",15,60), ("tin",68,45), ("banana",27,60), ("apple",39,40),
       ("cheese",23,30), ("beer",52,10), ("cream",11,70), ("camera",32,30),
       ("tshirt",24,15), ("trousers",48,10), ("umbrella",73,40),
       ("waterproof trousers",42,70), ("overclothes",43,75), ("notecase",22,80),
       ("sunglasses",7,20), ("towel",18,12), ("socks",4,50), ("book",30,10)]

knapsack = foldr addItem (repeat (0,[])) where
	addItem (name,w,v) list = left ++ zipWith max right newlist where
		newlist = map (\(val, names)->(val + v, name:names)) list
		(left,right) = splitAt w list

main = print $ (knapsack inv) !! 400
