(import (otus ffi))

(define self (load-dynamic-library #f))
(define strdup
   (self type-string "strdup" type-string))

(print (strdup "Hello World!"))
