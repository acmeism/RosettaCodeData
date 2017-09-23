(import (scheme base)
        (scheme write)
        (srfi 1))

;; return list of solutions to n-queens problem
(define (n-queens n) ; breadth-first solution
  (define (place-initial-row) ; puts a queen on each column of row 0
    (list-tabulate n (lambda (col) (list (cons 0 col)))))
  (define (place-on-row soln-so-far row)
    (define (invalid? col)
      (any (lambda (posn)
             (or (= col (cdr posn)) ; on same column
                 (= (abs (- row (car posn))) ; on same diagonal
                    (abs (- col (cdr posn))))))
           soln-so-far))
    ;
    (do ((col 0 (+ 1 col))
         (res '() (if (invalid? col)
                    res
                    (cons (cons (cons row col) soln-so-far)
                          res))))
      ((= col n) res)))
  ;
  (do ((res (place-initial-row)
            (apply append
                   (map (lambda (soln-so-far) (place-on-row soln-so-far row))
                        res)))
       (row 1 (+ 1 row)))
    ((= row n) res)))

;; display solutions in 2-d array form
(define (pretty-print solutions n)
  (define (posn->index posn)
    (+ (* n (cdr posn))
       (car posn)))
  (define (pp solution)
    (let ((board (make-vector (square n) ".")))
      (for-each (lambda (queen) (vector-set! board
                                             (posn->index queen)
                                             "Q"))
                solution)
      (let loop ((row 0)
                 (col 0))
        (cond ((= row n)
               (newline))
              ((= col n)
               (newline)
               (loop (+ 1 row) 0))
              (else
                (display (vector-ref board (posn->index (cons row col))))
                (loop row (+ 1 col)))))))
  ;
  (display (string-append "Found "
                          (number->string (length solutions))
                          " solutions for n="
                          (number->string n)
                          "\n\n"))
  (for-each pp solutions))

;; create table of number of solutions
(do ((n 1 (+ 1 n)))
  ((> n 10) )
  (display n)
  (display " ")
  (display (length (n-queens n)))
  (newline))

;; show some examples
(pretty-print (n-queens 1) 1)
(pretty-print (n-queens 2) 2)
(pretty-print (n-queens 3) 3)
(pretty-print (n-queens 4) 4)
(pretty-print (n-queens 5) 5)
(pretty-print (n-queens 8) 8)
