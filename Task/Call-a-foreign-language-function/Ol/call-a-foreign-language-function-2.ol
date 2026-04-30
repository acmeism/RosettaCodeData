(import (otus ffi))

(define libc (or
   (load-dynamic-library "libc.so") ; General Posix
   (load-dynamic-library "libc.so.6") ; Linux
   (load-dynamic-library "libc.so.6.1") ; Linux (DEC Alpha)
   (load-dynamic-library "libc.so.7") ; Latest *BSD
   (load-dynamic-library "libSystem.B.dylib") ; macOS / Darwin
   (load-dynamic-library "shlwapi.dll") )) ; Windows

(define strdup (or
   (libc type-string "strdup" type-string) ; All
   (libc type-string "StrDupA" type-string) )) ; Win

(print (strdup "Hello World!"))
