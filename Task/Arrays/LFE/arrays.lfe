; Create a fixed-size array with entries 0-9 set to 'undefined'
> (set a0 (: array new 10))
#(array 10 0 undefined 10)
> (: array size a0)
10

; Create an extendible array and set entry 17 to 'true',
; causing the array to grow automatically
> (set a1 (: array set 17 'true (: array new)))
#(array
  18
  ...
(: array size a1)
18

; Read back a stored value
> (: array get 17 a1)
true

; Accessing an unset entry returns the default value
> (: array get 3 a1)
undefined

; Accessing an entry beyond the last set entry also returns the
; default value, if the array does not have fixed size
> (: array get 18 a1)
undefined

; "sparse" functions ignore default-valued entries
> (set a2 (: array set 4 'false a1))
#(array
  18
  ...
> (: array sparse_to_orddict a2)
(#(4 false) #(17 true))

; An extendible array can be made fixed-size later
> (set a3 (: array fix a2))
#(array
  18
  ...

; A fixed-size array does not grow automatically and does not
; allow accesses beyond the last set entry
> (: array set 18 'true a3)
exception error: badarg
  in (array set 3)

> (: array get 18 a3)
exception error: badarg
  in (array get 2)
