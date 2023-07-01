" Creating a dynamic array with some initial values
let array = [3, 4]

" Retrieving an element
let four = array[1]

" Modifying an element
let array[0] = 2

" Appending a new element
call add(array, 5)

" Prepending a new element
call insert(array, 1)

" Inserting a new element before another element
call insert(array, 3, 2)

echo array
