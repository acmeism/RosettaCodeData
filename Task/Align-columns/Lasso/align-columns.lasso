#!/usr/bin/lasso9

local(text = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
")


define go_left(text::array, width::integer) => {
	local(output = string)
	with row in #text do {
		with word in #row do {
			#output -> append(string(#word) -> padtrailing(#width + 1)&)
		}
		#output -> append('\n')
	}
	return #output
}

define go_right(text::array, width::integer) => {
	local(output = string)
	with row in #text do {
		with word in #row do {
			#output -> append(string(#word) -> padleading(#width + 1)&)
		}
		#output -> append('\n')
	}
	return #output
}

define go_center(text::array, width::integer) => {
	local(output = string)
	with row in #text do {
		with word in #row do {
			local(
				padlength	= (#width + 1 - #word -> size),
				padleft		= (' ' * (#padlength / 2)),
				padright	= (' ' * (#padlength - #padleft -> size))
			)
			#output -> append(#padleft + string(#word) + #padright)
		}
		#output -> append('\n')
	}
	return #output
}

define prepcols(text::string) => {
	local(
		result		= array,
		maxwidth	= 0
	)
	with row in #text -> split('\n') do {
		#row -> removetrailing('$')
		#result -> insert(#row -> split('$'))
	}
	with word in delve(#result) do {
		#word -> size > #maxwidth ? #maxwidth = #word -> size
	}
	stdoutnl('Left aligned result: \n' + go_left(#result, #maxwidth))
	stdoutnl('Right aligned result: \n' + go_right(#result, #maxwidth))
	stdoutnl('Centered result: \n' + go_center(#result, #maxwidth))
}

prepcols(#text)
