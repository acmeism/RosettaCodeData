;; value for 'even' numbers
(define (even-val n) (if (> n 4) (+ n n -9) (+ n n)))

;;Luhn test
;; input : a string of decimal digits
;; output #t or #f
(define (valid nums (odd #f ))
    (let ((nums (map string->number (reverse (string->list nums)))))
    (= 0 (modulo
       (for/sum ((n nums)) (set! odd (not odd)) (if odd n (even-val n)))
       10))))

(valid "49927398716") → #t
(valid "1234567812345670") → #t
(valid "1234567812345678") → #f
(valid "49927398717") → #f
