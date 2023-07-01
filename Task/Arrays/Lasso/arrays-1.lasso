// Create a new empty array
local(array1) = array

// Create an array with 2 members (#myarray->size is 2)
local(array1) = array('ItemA','ItemB')

// Assign a value to member [2]
#array1->get(2) = 5

// Retrieve a value from an array
#array1->get(2) + #array1->size // 8

// Merge arrays
local(
    array1 = array('a','b','c'),
    array2 = array('a','b','c')
)
#array1->merge(#array2) // a, b, c, a, b, c

// Sort an array
#array1->sort // a, a, b, b, c, c

// Remove value by index
#array1->remove(2) // a, b, b, c, c

// Remove matching items
#array1->removeall('b') // a, c, c

// Insert item
#array1->insert('z')  // a, c, c, z

// Insert item at specific position
#array1->insert('0',1)  // 0, a, c, c, z
