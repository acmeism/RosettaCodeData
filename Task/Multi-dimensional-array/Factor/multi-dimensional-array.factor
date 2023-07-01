USING: accessors arrays.shaped io kernel prettyprint sequences ;

! Create a 4-dimensional array with increasing elements.
{ 2 3 4 5 } increasing

! Check if an index is in bounds.
{ 0 0 0 0 } over shaped-bounds-check

! Access and print the first element.
"First element: " write
get-shaped-row-major .

! Set the first element and show the array.
"With first element set to 999:" print
999 { 0 0 0 0 } pick set-shaped-row-major dup .

! Reshape and show the array.
"Reshaped: " print
{ 5 4 3 2 } reshape .
