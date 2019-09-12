; typical use:
(for-each display '(1 2 "ss" '(3 4) 8))
; ==> 12ss(quote (3 4))8'()

; manual implementation in details:
(define (do f x)
   (f x))
(do print 12345)
; ==> 12345
