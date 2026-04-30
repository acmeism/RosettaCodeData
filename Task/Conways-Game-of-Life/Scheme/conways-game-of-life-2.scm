(import (srfi 231))

(define (pad-array-with-zeros a N)

  ;; Pad two-dimensional array with N rows and columns of zeros,
  ;; top and bottom, left and right.
  ;; Assumes that the domain of a has zero lower bounds.

  (let* ((domain (array-domain a))
         (m      (interval-upper-bound domain 0))
         (n      (interval-upper-bound domain 1))
         (a_     (array-getter a)))
    (make-array (interval-dilate domain (vector (- N) (- N)) (vector N N))
                (lambda (i j)
                  (or (and (< -1 i m) (< -1 j n) (a_ i j))
                      0)))))

(define (neighbor-count a)

  ;; Returns a generalized array that contains the number
  ;; of 1s in the 8 cells surrounding each cell in the original array.

  (let* ((big-a      (array-copy! (pad-array-with-zeros a 1)
                                  (array-storage-class a)))
         (domain     (array-domain a))
         (translates (map (lambda (translation)
                            (array-extract (array-translate big-a translation) domain))
                          '(#(1 0) #(0 1) #(-1 0) #(0 -1)
                            #(1 1) #(1 -1) #(-1 1) #(-1 -1)))))
    (apply array-map + translates)))

(define (game-rules a neighbor-count)

  ;; a is the value in a single cell, neighbor-count is the count of 1s in
  ;; its 8 neighboring cells.

  (if (zero? a)
      (if (eqv? neighbor-count 3) 1 0)
      (if (<= 2 neighbor-count 3) 1 0)))

(define (advance a)
  (array-copy! (array-map game-rules a (neighbor-count a))
               (array-storage-class a)))

(define life-storage-class u1-storage-class)

(define glider
  (list*->array
   2
   '((0 0 0 0 0 0)
     (0 0 1 0 0 0)
     (0 0 0 1 0 0)
     (0 1 1 1 0 0)
     (0 0 0 0 0 0)
     (0 0 0 0 0 0))
   life-storage-class))

(do ((i 0 (+ i 1))
     (pattern glider (advance pattern)))
    ((= i 5))
  (pretty-print (array->list* pattern))
  (newline))
