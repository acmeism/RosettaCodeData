(import (scheme base)
        (scheme inexact)
        (scheme read)
        (scheme write)
        (srfi 13))   ;; for string-length and string-ref

(define *string-fractions* ; string input of fractions
  "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19
  1/17 11/13 13/11 15/14 15/2 55/1")

(define *fractions* ; create vector of fractions from string input
  (list->vector ; convert result to a vector, for constant access times
    (read (open-input-string ; read from the string of fractions, as a list
            (string-append "(" *string-fractions* ")")))))

;; run a fractran interpreter, returning the next number for n
;; or #f if no next number available
;; assume fractions: ordered vector of positive fractions
;;                n: a positive integer
(define (fractran fractions n)
  (let ((max-n (vector-length fractions)))
    (let loop ((i 0))
      (cond ((= i max-n)
             #f)
            ((integer? (* n (vector-ref fractions i)))
             (* n (vector-ref fractions i)))
            (else
              (loop (+ 1 i)))))))

;; Task
(define (display-result max-n)
  (do ((i 0 (+ 1 i))
       (n 2 (fractran *fractions* n)))
    ((= i max-n) (newline))
    (display n) (display " ")))

(display "Task: ")
(display-result 20) ; show first 20 numbers

;; Extra Credit: derive first 20 prime numbers
(define (generate-primes target-number initial-n)
  (define (is-power-of-two? n) ; a binary with only 1 "1" bit is a power of 2
    (cond ((<= n 2) ; exclude 2 and 1
           #f)
          (else
            (let loop ((i 0) (acc 0) (binary-str (number->string n 2)))
              (cond ((= i (string-length binary-str))
                     #t)
                    ((and (eq? (string-ref binary-str i) #\1) (= 1 acc))
                     #f)
                    ((eq? (string-ref binary-str i) #\1)
                     (loop (+ 1 i) (+ 1 acc) binary-str))
                    (else
                      (loop (+ 1 i) acc binary-str)))))))
  (define (extract-prime n) ; just gets the number of zeroes in binary
    (let ((binary-str (number->string n 2)))
      (- (string-length binary-str) 1)))
  ;
  (let loop ((count 0)
             (n initial-n))
    (when (< count target-number)
      (cond ((eq? n #f)
             (display "-- FAILED TO COMPUTE N --\n"))
            ((is-power-of-two? n)
             (display (extract-prime n)) (display " ")
             (loop (+ 1 count)
                   (fractran *fractions* n)))
            (else
              (loop count
                    (fractran *fractions* n))))))
  (newline))

(display "Primes:\n")
(generate-primes 20 2) ; create first 20 primes
