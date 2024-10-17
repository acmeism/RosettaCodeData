(import (scheme base)
        (scheme write)
        (srfi 27))     ; random numbers

(random-source-randomize! default-random-source)

(define target "METHINKS IT IS LIKE A WEASEL") ; target string
(define C 100) ; size of population
(define p 0.1) ; chance any char is mutated

;; return a random character in given range
(define (random-char)
  (string-ref "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
              (random-integer 27)))

;; compute distance of given string from target
(define (fitness str)
  (apply +
         (map (lambda (c1 c2) (if (char=? c1 c2) 0 1))
              (string->list str)
              (string->list target))))

;; mutate given parent string, returning a new string
(define (mutate str)
  (string-map (lambda (c)
                (if (< (random-real) p)
                  (random-char)
                  c))
              str))

;; create a population by mutating parent,
;; returning a list of variations
(define (make-population parent)
  (do ((pop '() (cons (mutate parent) pop)))
    ((= C (length pop)) pop)))

;; find the most fit candidate in given list
(define (find-best candidates)
  (define (select-best a b)
    (if (< (fitness a) (fitness b)) a b))
  ;
  (do ((best (car candidates) (select-best best (car rem)))
       (rem (cdr candidates) (cdr rem)))
    ((null? rem) best)))

;; create first parent from random characters
;; of same size as target string
(define (initial-parent)
  (do ((res '() (cons (random-char) res)))
    ((= (length res) (string-length target))
     (list->string res))))

;; run the search
(do ((parent (initial-parent) (find-best (cons parent (make-population parent))))) ; select best from parent and population
  ((string=? parent target)
   (display (string-append "Found: " parent "\n")))
  (display parent) (newline))
