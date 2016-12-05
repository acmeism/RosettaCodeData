// In Lasso associative arrays are called maps

// Define an empty map
local(mymap = map)

// Define a map with content
local(mymap = map(
	'one'	= 'Monday',
	'2'	= 'Tuesday',
	3	= 'Wednesday'
))

// add elements to an existing map
#mymap -> insert('fourth' = 'Thursday')

// retrieve a value from a map
#mymap -> find('2') // Tuesday
'<br />'
#mymap -> find(3) // Wednesday, found by the key not the position
'<br />'

// Get all keys from a map
#mymap -> keys // staticarray(2, fourth, one, 3)
'<br />'

// Iterate thru a map and get values
with v in #mymap do {^
	#v
	'<br />'
^}
// Tuesday<br />Thursday<br />Monday<br />Wednesday<br />

// Perform actions on each value of a map
#mymap -> foreach => {
	#1 -> uppercase
	#1 -> reverse
}
#mymap // map(2 = YADSEUT, fourth = YADSRUHT, one = YADNOM, 3 = YADSENDEW)
