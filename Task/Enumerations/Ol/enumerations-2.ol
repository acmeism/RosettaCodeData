; simple function to create enumeration with autoassigning values
(define (make-enumeration . args)
   (fold (lambda (ff arg i)
            (put ff arg i))
      #empty
      args
      (iota (length args))))

(make-enumeration 'apple 'banana 'cherry)
; ==> '#ff((apple . 0) (banana . 1) (cherry . 2))
