>>forall data [either (index? data) = 1[
	append data/1 "SUM"
][
	append data/1 to string!
	(to integer! data/1/1) + (to integer! data/1/2) + (to integer! data/1/3) + (to integer! data/1/4) + (to integer! data/1/5)
]]
