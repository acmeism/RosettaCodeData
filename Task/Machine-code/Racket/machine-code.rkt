#lang racket/base

(require ffi/unsafe)

; set up access to racket internals
(define scheme-malloc-code
  (get-ffi-obj 'scheme_malloc_code #f (_fun (len : _intptr) -> _pointer)))
(define scheme-free-code
  (get-ffi-obj 'scheme_free_code #f (_fun _pointer -> _void)))

(define opcodes '(139 68 36 4 3 68 36 8 195))

(define code (scheme-malloc-code 64))

(for ([byte opcodes]
      [i (in-naturals)])
  (ptr-set! code _ubyte i byte))

(define function (cast code _pointer (_fun _ubyte _ubyte -> _ubyte)))

(function 7 12)

(scheme-free-code code)
