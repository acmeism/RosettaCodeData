(define level '(
   (1 1 1 1 1 1 1 1 1 1)
   (1 A 0 0 0 0 0 0 0 1)
   (1 0 0 0 0 0 0 0 0 1)
   (1 0 0 0 0 1 1 1 0 1)
   (1 1 0 0 0 0 0 1 0 1)
   (1 0 0 1 0 0 0 1 0 1)
   (1 0 0 1 1 1 1 1 0 1)
   (1 0 0 0 0 0 0 0 0 1)
   (1 0 0 0 1 0 0 0 B 1)
   (1 1 1 1 1 1 1 1 1 1)
))
(for-each print level)

; let's check that we can't move to (into wall)
(print (A* level '(1 . 1) '(9 . 9)))

(define to '(8 . 8))
(define (plus a b) (cons (+ (car a) (car b)) (+ (cdr a) (cdr b)))) ; helper

(define path
(let loop ((me '(1 . 1)) (path '()))
   (if (equal? me to)
      (begin
         (print "here I am!")
         (cons to path))
   (let ((move (A* level me to)))
      (unless move
         (begin
            (print "no way, sorry :(")
            #false)
         (let ((step (plus me move)))
            (print me " + " move " -> " step)
            (loop step (cons me path))))))))

; let's draw the path?
(define (has? lst x) ; helper
   (cond
      ((null? lst) #false)
      ((equal? (car lst) x) lst)
      (else (has? (cdr lst) x))))

(define solved
   (map (lambda (row y)
         (map (lambda (cell x)
               (cond
                  ((equal? (cons x y) '(1 . 1)) "A")
                  ((equal? (cons x y) '(8 . 8)) "B")
                  ((has? path (cons x y)) "*")
                  (else cell)))
            row (iota 10)))
      level (iota 10)))

(for-each print solved)
