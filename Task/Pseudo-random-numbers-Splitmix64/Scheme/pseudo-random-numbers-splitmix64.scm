(use-modules (srfi srfi-1) (srfi srfi-60) (srfi srfi-26))

(define (mask64 x)
  (bitwise-and x #xFFFFFFFFFFFFFFFF))
(define ash arithmetic-shift)

(define (splitmix64 seed)
  (let ((state seed))
    (lambda ()
      (set! state (mask64 (+ state #x9e3779b97f4a7c15)))
      (let* ((z state)
             (z (mask64 (* (bitwise-xor z (ash z -30))
                           #xbf58476d1ce4e5b9)))
             (z (mask64 (* (bitwise-xor z (ash z -27))
                           #x94d049bb133111eb))))
        (mask64 (bitwise-xor z (ash z -31)))))))

(define (bytes->float N)
  (/ N (ash 1 64)))

(define (chi-sqr rng n k)
  (let* ((bins (list-tabulate n
                (lambda (_)
                 (floor (* (rng) k)))))
         (counts (list-tabulate k
                  (lambda (i)
                   (count (cut = <> i) bins))))
         (exp (/ n k)))
    (fold (lambda (obs acc)
           (+ acc (/ (expt (- obs exp) 2) exp)))
          0.0 counts)))

(display "Chi Squared: ")
(display (chi-sqr (compose bytes->float (splitmix64 42)) 1e6 16))
(newline) (display "Expected: <16.92 for 95%") (newline)
