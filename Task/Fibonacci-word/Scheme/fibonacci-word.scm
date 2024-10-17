(import (scheme base)
        (scheme inexact)
        (scheme write))

(define *words* (make-vector 38 ""))

(define (create-words)
  (vector-set! *words* 1 "1")
  (vector-set! *words* 2 "0")
  (do ((i 3 (+ 1 i)))
    ((= i (vector-length *words*)) )
    (vector-set! *words* i (string-append (vector-ref *words* (- i 1))
                                           (vector-ref *words* (- i 2))))))

;; in this context, word only contains 1 or 0
(define (entropy word)
  (let* ((N (string-length word))
         (num-ones 0)
         (num-zeros 0))
    (string-for-each (lambda (c)
                       (if (char=? c #\1)
                         (set! num-ones (+ 1 num-ones))
                         (set! num-zeros (+ 1 num-zeros))))
                     word)
    (if (or (zero? num-ones) (zero? num-zeros))
      0
      (- 0
         (* (/ num-ones N) (log (/ num-ones N) 2))
         (* (/ num-zeros N) (log (/ num-zeros N) 2))))))

;; display values
(create-words)
(do ((i 1 (+ 1 i)))
  ((= i (vector-length *words*)) )
  (display (string-append (number->string i)
                          " "
                          (number->string
                            (string-length (vector-ref *words* i)))
                          " "
                          (number->string
                            (entropy (vector-ref *words* i)))
                          "\n")))
