(define (monotonic-substr str (key-func or) (cmp =))
  (let (expl (explode str))
    (map join (monotonic-slices expl key-func cmp))))

(define (foo str)
  (join (monotonic-substr str) ", "))

(println (foo "gHHH5YY++///\\"))

g, HHH, 5, YY, ++, ///, \
