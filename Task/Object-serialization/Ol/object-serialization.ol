$ ol
Welcome to Otus Lisp 1.2,
type ',help' to help, ',quit' to end session.
> (define Object (tuple
   '(1 2 3 4)  ; list
   #(4 3 2 1)  ; bytevector
   "hello"     ; ansi string
   "こんにちは"  ; unicode string
   (list->ff '(; associative array
      (1 . 123456)
      (2 . second)
      (3 . "-th-")))
   #false      ; value
   -123        ; short number
   123456789012345678901234567890123456789  ; long number
)
;; Defined Object
#[(1 2 3 4) #u8(4 3 2 1) hello こんにちは #((1 . 123456) (2 . second) (3 . -th-)) #false -123 123456789012345678901234567890123456789]

> (fasl-save Object "/tmp/object.bin")
#true

> (define New (fasl-load "/tmp/object.bin" #false))
;; Defined New
#[(1 2 3 4) #u8(4 3 2 1) hello こんにちは #((1 . 123456) (2 . second) (3 . -th-)) #false -123 123456789012345678901234567890123456789]

> (equal? Object New)
#true

> ,quit
bye-bye :/
$
