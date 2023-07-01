// Create a staticarray containing 5 items
local(mystaticArray) = staticarray('a','b','c','d','e')

// Retreive an item
#mystaticArray->get(3) // c

// Set an item
#mystaticArray->get(3) = 'changed' // a, b, changed, d, e

// Create an empty static array with a length of 32
local(mystaticArray) = staticarray_join(32,void)
