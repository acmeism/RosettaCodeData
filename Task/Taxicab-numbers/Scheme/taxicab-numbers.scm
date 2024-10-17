(import (scheme base)
        (scheme write)
        (srfi 1)        ; lists
        (srfi 69)       ; hash tables
        (srfi 132))     ; sorting

(define *max-n* 1500) ; let's go up to here, maximum for x and y
(define *numbers* (make-hash-table eqv?)) ; hash table for total -> list of list of pairs

(define (retrieve key) (hash-table-ref/default *numbers* key '()))

;; add all combinations to the hash table
(do ((i 1 (+ i 1)))
  ((= i *max-n*) )
  (do ((j (+ 1 i) (+ j 1)))
    ((= j *max-n*) )
    (let ((n (+ (* i i i) (* j j j))))
      (hash-table-set! *numbers* n
                       (cons (list i j) (retrieve n))))))

(define (display-number i key)
  (display (+ 1 i)) (display ": ")
  (display key) (display " -> ")
  (display (retrieve key)) (newline))

(let ((sorted-keys (list-sort <
                              (filter (lambda (key) (> (length (retrieve key)) 1))
                                      (hash-table-keys *numbers*)))))
  ;; first 25
  (for-each (lambda (i) (display-number i (list-ref sorted-keys i)))
            (iota 25))
  ;; 2000-2006
  (for-each (lambda (i) (display-number i (list-ref sorted-keys i)))
            (iota 7 1999))
  )
