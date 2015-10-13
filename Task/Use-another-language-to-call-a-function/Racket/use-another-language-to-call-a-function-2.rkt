#lang racket

(require ffi/unsafe)

(define xlib (ffi-lib "./x.so"))

(set-ffi-obj! "Query" xlib (_fun _pointer _pointer -> _bool)
  (λ(bs len)
    (define out #"Here I am")
    (let ([bs (make-sized-byte-string bs (ptr-ref len _int))])
      (and ((bytes-length out) . <= . (bytes-length bs))
           (begin (bytes-copy! bs 0 out)
                  (ptr-set! len _int (bytes-length out))
                  #t)))))

((get-ffi-obj "main" xlib (_fun _int (_list i _bytes) -> _void))
 0 '())
