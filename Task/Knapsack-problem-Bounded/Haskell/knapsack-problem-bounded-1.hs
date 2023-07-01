inv = 	[("map",9,150,1), ("compass",13,35,1), ("water",153,200,2), ("sandwich",50,60,2),
	("glucose",15,60,2), ("tin",68,45,3), ("banana",27,60,3), ("apple",39,40,3),
	("cheese",23,30,1), ("beer",52,10,3), ("cream",11,70,1), ("camera",32,30,1),
	-- what to do if we end up taking one trouser?
	("tshirt",24,15,2), ("trousers",48,10,2), ("umbrella",73,40,1), ("wtrousers",42,70,1),
	("woverclothes",43,75,1), ("notecase",22,80,1), ("sunglasses",7,20,1), ("towel",18,12,2),
	("socks",4,50,1), ("book",30,10,2)]

knapsack = foldr addItem (repeat (0,[])) where
	addItem (name,w,v,c) old = foldr inc old [1..c] where
		inc i list = left ++ zipWith max right new where
			(left, right) = splitAt (w * i) list
			new = map (\(val,itms)->(val + v * i, (name,i):itms)) old

main = print $ (knapsack inv) !! 400
