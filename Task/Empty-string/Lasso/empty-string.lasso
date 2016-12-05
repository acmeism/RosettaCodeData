//Demonstrate how to assign an empty string to a variable.
local(str = string)
local(str = '')

//Demonstrate how to check that a string is empty.
#str->size == 0 	// true
not #str->size		// true

//Demonstrate how to check that a string is not empty.
local(str = 'Hello, World!')
#str->size > 0 		// true
#str->size		// true
