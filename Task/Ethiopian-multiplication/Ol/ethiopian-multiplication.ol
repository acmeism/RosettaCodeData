(define (ethiopian-multiplication l r)
   (let ((even? (lambda (n)
                  (eq? (mod n 2) 0))))

   (let loop ((sum 0) (l l) (r r))
      (print "sum: " sum ", l: " l ", r: " r)
      (if (eq? l 0)
         sum
         (loop
            (if (even? l) (+ sum r) sum)
            (floor (/ l 2)) (* r 2))))))

(print (ethiopian-multiplication 17 34))
