(define (number->list num)
   (let loop ((num num) (lst #null))
      (if (zero? num)
         lst
         (loop (quotient num 10) (cons (remainder num 10) lst)))))

(define (** x) (* x x))

(define (happy? num)
   (let loop ((num num) (seen #null))
      (cond
         ((= num 1) #true)
         ((memv num seen) #false)
         (else
            (loop (apply + (map ** (number->list num)))
                  (cons num seen))))))

(display "happy numbers: ")
(let loop ((n 1) (count 0))
   (unless (= count 8)
      (if (happy? n)
         then
            (display n) (display " ")
            (loop (+ n 1) (+ count 1))
         else
            (loop (+ n 1) count))))
(print)
