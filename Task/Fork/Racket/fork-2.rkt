#lang racket
(require ffi/unsafe)
(define fork (get-ffi-obj 'fork #f (_fun -> _int)))
(printf ">>> fork() => ~s\n" (fork))
