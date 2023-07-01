local(
	x = array(3,4,8,1,8,1,4,5,6,8,9,6),
	y = array
)
with n in #x where #y !>> #n do => { #y->insert(#n) }
// result: array(3, 4, 8, 1, 5, 6, 9)
