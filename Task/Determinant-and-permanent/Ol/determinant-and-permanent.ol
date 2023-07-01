; helper function that returns rest of matrix by col/row
(define (rest matrix i j)
   (define (exclude1 l x) (append (take l (- x 1)) (drop l x)))
   (exclude1
      (map exclude1
         matrix (repeat i (length matrix)))
      j))

; superfunction for determinant and permanent
(define (super matrix math)
   (let loop ((n (length matrix)) (matrix matrix))
      (if (eq? n 1)
         (caar matrix)
         (fold (lambda (x a j)
                  (+ x (* a (lref math (mod j 2)) (super (rest matrix j 1) math))))
            0
            (car matrix)
            (iota n 1)))))


; det/per calculators
(define (det matrix) (super matrix '(-1 1)))
(define (per matrix) (super matrix '( 1 1)))

; ---=( testing )=---------------------
(print (det '(
   (1 2)
   (3 4))))
; ==> -2

(print (per '(
   (1 2)
   (3 4))))
; ==> 10


(print (det '(
   ( 1  2  3  1)
   (-1 -1 -1  2)
   ( 1  3  1  1)
   (-2 -2  0 -1))))
; ==> 26

(print (per '(
   ( 1  2  3  1)
   (-1 -1 -1  2)
   ( 1  3  1  1)
   (-2 -2  0 -1))))
; ==> -10


(print (det '(
   ( 0  1  2  3  4)
   ( 5  6  7  8  9)
   (10 11 12 13 14)
   (15 16 17 18 19)
   (20 21 22 23 24))))
; ==> 0

(print (per '(
   ( 0  1  2  3  4)
   ( 5  6  7  8  9)
   (10 11 12 13 14)
   (15 16 17 18 19)
   (20 21 22 23 24))))
; ==> 6778800
