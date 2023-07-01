(define (extract ll)
   (let loop ((head (car ll)) (tail (cdr ll)) (out #null))
      (if (null? tail)
         (reverse (cons head out))
      else
         (cond
            ((eq? head (- (car tail) 1))
               (loop (list (car tail) head) (cdr tail) out))
            ((and (pair? head) (eq? (car head) (- (car tail) 1)))
               (loop (cons (car tail) head) (cdr tail) out))
            (else
               (loop (car tail) (cdr tail) (cons head out)))))))

(define (range->string range)
   (fold (lambda (f v)
            (string-append (if f (string-append f ",") "")
               (if (pair? v)
                  (string-append (string-append (number->string (last v #f)) "-")(number->string (car v)))
                  (number->string v))))
      #false
      range))

; let's test
(define data '(0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39))
(define range (extract data))

(print "extracted ranges: " range)
(print "string representation: " (range->string range))
