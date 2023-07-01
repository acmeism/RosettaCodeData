inv = [("map",9,150), ("compass",13,35), ("water",153,200), ("sandwich",50,160),
	("glucose",15,60), ("tin",68,45), ("banana",27,60), ("apple",39,40),
	("cheese",23,30), ("beer",52,10), ("cream",11,70), ("camera",32,30),
	("tshirt",24,15), ("trousers",48,10), ("umbrella",73,40), ("trousers",42,70),
	("overclothes",43,75), ("notecase",22,80), ("sunglasses",7,20), ("towel",18,12),
	("socks",4,50), ("book",30,10)]

combs [] _ = (0, [])
combs ((name,w,v):rest) cap
	| w <= cap  = max skipthis $ prepend (name,w,v) (combs rest (cap - w))
	| otherwise = skipthis
	where	prepend (name,w,v) (v2, lst) = (v2 + v, (name,w,v):lst)
		skipthis = combs rest cap

main = do print $ combs inv 400
