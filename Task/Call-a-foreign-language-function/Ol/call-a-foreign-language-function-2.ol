(import (otus ffi))

(if (not (has? *features* 'Windows))
   (print "The host platform is not a Windows!"))

(define self (load-dynamic-library "shlwapi.dll"))
(define strdup (self type-string "StrDupA" type-string))

(print (strdup "Hello World!"))
