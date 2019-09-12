; Because argument "k" is a small number, it's a value, not an object.
; So we must 'pack' it in object - 'box' it; And 'unbox' when we try to get value.

(define (box x)  (list x))
(define (unbox x) (car x))
(define (copy x) (box (unbox x)))

(define (A k x1 x2 x3 x4 x5)
   (define (B)
      (set-car! k (- (unbox k) 1))
      (A (copy k) B x1 x2 x3 x4))

   (if (<= (unbox k) 0)
      (+ (x4) (x5))
      (B)))

(define (man-or-boy N)
   (A (box N)
      (lambda ()  1)
      (lambda () -1)
      (lambda () -1)
      (lambda ()  1)
      (lambda () 0)))

(print (man-or-boy 10))
(print (man-or-boy 15))
(print (man-or-boy 20))
