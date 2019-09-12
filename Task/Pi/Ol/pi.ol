; 'numbers' is count of numbers or #false for eternal pleasure.
(define (pi numbers)
   (let loop ((q 1) (r 0) (t 1) (k 1) (n 3) (l 3) (numbers numbers))
      (unless (eq? numbers 0)
         (if (< (- (+ (* 4 q) r) t) (* n t))
            (begin
               (display n)
               (loop (* q  10)
                     (* 10 (- r (* n t)))
                     t
                     k
                     (- (div (* 10 (+ (* 3 q) r)) t) (* 10 n))
                     l
                     (if numbers (- numbers 1))))
            (begin
               (loop (* q k)
                     (* (+ (* 2 q) r) l)
                     (* t l)
                     (+ k 1)
                     (div (+ (* q (* 7 k)) 2 (* r l)) (* t l))
                     (+ l 2)
                     (if numbers (- numbers 1))))))))

(pi #false)
