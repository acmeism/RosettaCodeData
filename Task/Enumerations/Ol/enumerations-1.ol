(define fruits '{
   apple  0
   banana 1
   cherry 2})
; or
(define fruits {
   'apple  0
   'banana 1
   'cherry 2})

; getting enumeration value:
(get fruits 'apple -1) ; ==> 0
; or simply
(fruits 'apple)        ; ==> 0
; or simply with default (for non existent enumeration key) value
(fruits 'carrot -1)    ; ==> -1
