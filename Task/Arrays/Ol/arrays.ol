; making an array
#(1 2 3 4 5)

; making an empty array
#()
#0

; making n-length array with undefined values (actually, #false)
(make-array 5)

; making n-length array with default value
(make-array 5 0)

; getting n-th element of array
(ref array 1)
