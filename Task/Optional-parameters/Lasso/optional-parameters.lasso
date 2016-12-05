define sortarray( // params are set by position
	items::array, // required param
	ordering::string	= 'lexicographic', // optional param
	column::integer		= 1,
	reverse::boolean	= false
) => {
	// sorting process
	local(sorteditems = array)
	// Lasso has no build in method to sort an array of arrays by position in the contained arrays
	// But a method could be built for it
	return #sorteditems
}

define sortarray(
	-items::array, // required param
	-ordering::string	= 'lexicographic', // optional param
	-column::integer	= 1,
	-reverse::boolean	= false
) => sortarray(#items, #ordering, #column, #reverse)

local(items = array(
	array(10, 'red', 'Volvo'),
	array(15, 'gren', 'Ford'),
	array(48, 'yellow', 'Kia'),
	array(12, 'black', 'Holden'),
	array(19, 'brown', 'Fiat'),
	array(8, 'pink', 'Batmobile'),
	array(74, 'orange', 'Bicycle')
))

sortarray(-items = #items, -reverse)

sortarray(#items)
