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
(print (get fruits 'apple -1)) ; ==> 0
; or simply
(print (fruits 'apple))        ; ==> 0
; or simply with default (for non existent enumeration key) value
(print (fruits 'carrot -1))    ; ==> -1

; simple function to create enumeration with autoassigning values
(define (make-enumeration . args)
   (fold (lambda (ff arg i)
            (put ff arg i))
      #empty
      args
      (iota (length args))))

(print (make-enumeration 'apple 'banana 'cherry))
; ==> '#ff((apple . 0) (banana . 1) (cherry . 2))
