; making a vector
> #(1 2 3 4 5)
#(1 2 3 4 5)

; making a vector in a functional way
> (vector 1 2 3 4 5)
#(1 2 3 4 5)

; another functional vector making way
> (make-vector '(1 2 3 4 5))
#(1 2 3 4 5)

; the same as above functional vector making way
> (list->vector '(1 2 3 4 5))
#(1 2 3 4 5)

; modern syntax of making a vector
> [1 2 3 4 5]
#(1 2 3 4 5)

; making a vector of symbols
> '[a b c d e]
#(a b c d e)

; making a vector of symbols but evaluate a third element
> `[a b ,(* 7 13) d e]
#(a b 91 d e)

; making an empty vectors
> #()
#()

> []
#()

> '[]
#()

> `[]
#()

> (make-vector '())
#()

> (list->vector '())
#()

; making a vector of a vectors (a matrix, for example)
> [[1 2 3]
   [4 5 6]
   [7 8 9]]
#(#(1 2 3) #(4 5 6) #(7 8 9))

; getting length of a vector
> (size [1 2 3 4 5])
5

; making n-length vector with undefined values (actually, #false)
> (make-vector 5)
#(#false #false #false #false #false)

; making n-length vector with default values
> (make-vector 5 0)
#(0 0 0 0 0)

; define a test vector for use in below
> (define array [3 5 7 9 11])
;; Defined array

; getting first element of a vector
> (ref array 1)
3

> (ref array (- (size array)))
3

; getting last element of a vector
> (ref array (size array))
11

> (ref array -1)
11

; vectors comparison
> (equal? [1 2 3 4 5] [1 2 3 4 5])
#true

> (equal? [1 2 3 4 5] [7 2 3 4 5])
#false

; vectors of vectors comparison
> (equal?
   [[1 2 3]
    [4 5 6]
    [7 8 9]]
   [[1 2 3]
    [4 5 6]
    [7 8 9]])
#true

> (equal?
   [[1 2 3]
    [4 5 6]
    [7 8 9]]
   [[1 2 3]
    [4 5 6]
    [7 8 3]])
#false
