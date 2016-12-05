#!/usr/bin/lasso9

local(collection =
	array(
		array,
		array("ABC"),
		array("ABC", "DEF"),
		array("ABC", "DEF", "G", "H")
	)
)

with words in #collection do {
	if(#words -> size > 1) => {
		local(last = #words -> last)
		#words -> removelast
		stdoutnl('{' + #words -> join(', ') + ' and ' + #last'}')
	else(#words -> size == 1)
		stdoutnl('{' + #words -> first + '}')
	else
		stdoutnl('{}')
	}

}
