define greatest(a::array) => {
	return (#a->sort&)->last
}

local(x = array(556,1,7344,4,7,52,22,55,88,122,55,99,1222,578))
greatest(#x)
