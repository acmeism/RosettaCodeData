; simple FFI interface on Mac OSX
(import "libc.dylib" "strdup")
(println (get-string (strdup "hello world")))

; or extended FFI interface on Mac OSX
(import "libc.dylib" "strdup" "char*" "char*")
(println (strdup "hello world"))
