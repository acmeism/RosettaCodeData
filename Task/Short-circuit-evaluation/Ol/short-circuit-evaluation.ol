(define (a x)
   (print "   (a) => " x)
   x)

(define (b x)
   (print "   (b) => " x)
   x)

; and
(print " -- and -- ")
(for-each (lambda (x y)
      (print "let's evaluate '(a as " x ") and (b as " y ")':")
      (let ((out (and (a x) (b y))))
         (print "   result is " out)))
   '(#t #t #f #f)
   '(#t #f #t #f))

; or
(print " -- or -- ")
(for-each (lambda (x y)
      (print "let's evaluate '(a as " x ") or (b as " y ")':")
      (let ((out (or (a x) (b y))))
         (print "   result is " out)))
   '(#t #t #f #f)
   '(#t #f #t #f))
