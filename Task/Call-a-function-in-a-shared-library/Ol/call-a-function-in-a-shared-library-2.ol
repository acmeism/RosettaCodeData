(import (otus ffi))

(define self (load-dynamic-library #f))
(define strdup
   (let ((strdup (self type-vptr "strdup" type-string))
         (free   (self fft-void "free" type-vptr)))
      (lambda (str)
         (let*((dupped (strdup str))
               (result (vptr->string dupped)))
            (free dupped)
            result))))

(print (strdup "Hello World!"))
