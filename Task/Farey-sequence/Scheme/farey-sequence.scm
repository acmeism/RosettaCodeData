(import (scheme base)
        (scheme write))

;; create a generator for Farey sequence n
;; using next term formula from https://en.wikipedia.org/wiki/Farey_sequence
(define (farey-generator n)
  (let ((a #f) (b 1) (c #f) (d n))
    (lambda ()
      (cond ((not a)    ; first item in sequence
             (set! a 0)
             (/ a b))
            ((not c)    ; second item in sequence
             (set! c 1)
             (/ c d))
            ((= c d)    ; return #f when finished sequence
             #f)
            (else       ; compute next term
              (let* ((f (floor (/ (+ n b) d)))
                     (p (- (* f c) a))
                     (q (- (* f d) b)))
                (set! a c)
                (set! b d)
                (set! c p)
                (set! d q)
                (/ p q)))))))

(define (farey-sequence n display?)
  (define (display-rat n) ; ensure 0,1 show /1
    (display n)
    (when (= 1 (denominator n))
      (display "/1"))
    (display " "))
  ;
  (let ((gen (farey-generator n)))
    (do ((res (gen) (gen))
         (count 0 (+ 1 count)))
      ((not res) (when display? (newline))
                 count)
      (when display? (display-rat res)))))

;;

(display "Farey sequence for order 1 through 11 (inclusive):\n")
(do ((i 1 (+ i 1)))
  ((> i 11) )
  (display (string-append "F(" (number->string i) "): "))
  (farey-sequence i #t))

(display "\nNumber of fractions in the Farey sequence:\n")
(do ((i 100 (+ i 100)))
  ((> i 1000) )
  (display
    (string-append "F(" (number->string i) ") = "
                   (number->string (farey-sequence i #f))))
  (newline))
