|array|
"creates an array that holds up to 20 elements"
array := Array new: 20 .
"access the first element: array base is 1"
(array at: 1) displayNl.
"put 100 as second value; you can put any object,
 in particular SmallInteger"
array at: 2 put: 100.
"initialize an array from a 'constant' given array"
array := Array withAll: #('an' 'apple' 'a' 'day' 'keeps' 'the' 'doctor' 'away').
"Replacing apple with orange"
array at: 2 put: 'orange'.
