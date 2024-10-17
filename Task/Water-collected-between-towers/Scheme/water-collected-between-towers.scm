(import (scheme base)
        (scheme write))

(define (total-collected chart)
  (define (highest-left vals curr)
    (if (null? vals)
      (list curr)
      (cons curr
            (highest-left (cdr vals) (max (car vals) curr)))))
  (define (highest-right vals curr)
    (reverse (highest-left (reverse vals) curr)))
  ;
  (if (< (length chart) 3) ; catch the end cases
    0
    (apply +
           (map (lambda (l c r)
                  (if (or (<= l c)
                          (<= r c))
                    0
                    (- (min l r) c)))
                (highest-left chart 0)
                chart
                (highest-right chart 0)))))

(for-each
  (lambda (chart)
    (display chart) (display " -> ") (display (total-collected chart)) (newline))
  '((1 5 3 7 2)
    (5 3 7 2 6 4 5 9 1 2)
    (2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1)
    (5 5 5 5)
    (5 6 7 8)
    (8 7 7 6)
    (6 7 10 7 6)))
