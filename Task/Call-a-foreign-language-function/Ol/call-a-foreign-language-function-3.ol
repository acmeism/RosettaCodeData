(import (otus ffi))

(define libc (or
   (load-dynamic-library "libc.so") ; General Posix
   (load-dynamic-library "libc.so.6") ; Linux
   (load-dynamic-library "libc.so.6.1") ; Linux (DEC Alpha)
   (load-dynamic-library "libc.so.7") ; Latest *BSD
   (load-dynamic-library "libSystem.B.dylib") ; macOS / Darwin
   (load-dynamic-library "shlwapi.dll") )) ; Windows

(define lib2
   (load-dynamic-library "kernel32.dll")) ; Windows

(define strdup
   (let ((strdup (or
            (libc type-vptr "strdup" type-string) ; All
            (libc type-vptr "StrDupA" type-string))) ; Win
         (free (or
            (libc fft-void "free" type-vptr) ; All
            (lib2 fft-void "LocalFree" type-vptr)))) ; Win
      (lambda (str)
         (let*((dupped (strdup str))
               (result (vptr->string dupped)))
            (free dupped)
            result))))

(print (strdup "Hello World!"))
