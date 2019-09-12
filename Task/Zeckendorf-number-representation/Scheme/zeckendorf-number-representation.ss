(import (rnrs))

(define (getFibList maxNum n1 n2 fibs)
  (if (> n2 maxNum)
      fibs
      (getFibList maxNum n2 (+ n1 n2) (cons n2 fibs))))

(define (getZeckendorf num)
  (if (<= num 0)
      "0"
      (let ((fibs (getFibList num 1 2 (list 1))))
        (getZeckString "" num fibs))))

(define (getZeckString zeck num fibs)
  (let* ((curFib (car fibs))
         (placeZeck (>= num curFib))
         (outString (string-append zeck (if placeZeck "1" "0")))
         (outNum (if placeZeck (- num curFib) num)))
    (if (null? (cdr fibs))
        outString
        (getZeckString outString outNum (cdr fibs)))))

(let loop ((i 0))
  (when (<= i 20)
    (for-each
      (lambda (item)
        (display item))
      (list "Z(" i "):\t" (getZeckendorf i)))
    (newline)
    (loop (+ i 1))))
