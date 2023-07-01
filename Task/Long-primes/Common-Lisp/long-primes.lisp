; Primality test using the Sieve of Eratosthenes with a couple minor optimizations
(defun primep (n)
   (cond ((and (<= n 3) (> n 1)) t)
         ((some #'zerop (mapcar (lambda (d) (mod n d)) '(2 3))) nil)
         (t (loop for i = 5 then (+ i 6)
                while (<= (* i i) n)
                 when (some #'zerop (mapcar (lambda (d) (mod n (+ i d))) '(0 2))) return nil
              finally (return t)))))

; Translation of the long-prime algorithm from the Raku solution
(defun long-prime-p (n)
  (cond
    ((< n 3) nil)
    ((not (primep n)) nil)
    (t (let* ((rr (loop repeat (1+ n)
                           for r = 1 then (mod (* 10 r) n)
                       finally (return r)))

              (period (loop for p = 0 then (1+ p)
                            for r = (mod (* 10 rr) n) then (mod (* 10 r) n)
                          while (and (< p n) (/= r rr))
                        finally (return (1+ p)))))

         (= period (1- n))))))

(format t "~{~a~^, ~}" (loop for n from 1 to 500 if (long-prime-p n) collect n))
