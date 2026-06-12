(define base64-codes "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
(define kernel (alist->ff (map cons (iota (string-length base64-codes)) (string->bytes base64-codes))))

; returns n bits from input binary stream
(define (bits n hold)
   (let loop ((hold hold))
      (vector-apply hold (lambda (v i l)
         (cond
            ; usual case
            ((pair? l)
               (if (not (less? i n))
                  (values (>> v (- i n)) (vector (band v (- (<< 1 (- i n)) 1)) (- i n) l))
                  (loop (vector
                     (bor (<< v 8) (car l))
                     (+ i 8)
                     (cdr l)))))
            ; special case - no more characters in input stream
            ((null? l)
               (cond
                  ((= i 0)
                     (values #false #false)) ; done
                  ((< i n)
                     (values (<< v (- n i)) (vector 0 0 #null)))
                  (else
                     (values (>> v (- i n)) (vector (band v (- (<< 1 (- i n)) 1)) (- i n) #null)))))
            ; just stream processing
            (else
               (loop (vector v i (force l)))))))))

; decoder.
(define (encode str)
   (case (mod
            (let loop ((hold [0 0 (str-iter str)]) (n 0))
               (let*((bit hold (bits 6 hold)))
                  (when bit (display (string (kernel bit))))
                  (if (not hold)
                     n
                     (loop hold (+ n 1)))))
            4)
      (2 (print "=="))
      (3 (print "="))
      (else (print))))

(encode "Hello, Lisp!")

(encode "To err is human, but to really foul things up you need a computer.\n    -- Paul R. Ehrlich")

(encode "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.")
