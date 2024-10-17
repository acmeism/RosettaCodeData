(import (scheme base)
        (scheme write)
        (srfi 1 lists)) ; use 'fold' from SRFI 1

;; convert number to a list of digits, in desired base
(define (r-number->list n base)
  (let loop ((res '())
             (num n))
    (if (< num base)
      (cons num res)
      (loop (cons (remainder num base) res)
            (quotient num base)))))

;; convert number to string, in desired base
(define (r-number->string n base)
  (apply string-append
         (map number->string
              (r-number->list n base))))

;; test if a list of digits is a palindrome
(define (palindrome? lst)
  (equal? lst (reverse lst)))

;; based on Perl/Ruby's insight
;; -- construct the ternary palindromes in order
;;    using fact that their central number is always a 1
;; -- convert into binary, and test if result is a palindrome too
(define (get-series size)
  (let loop ((results '(1 0))
             (i 1))
    (if (= size (length results))
      (reverse results)
      (let* ((n3 (r-number->list i 3))
             (n3-list (append n3 (list 1) (reverse n3)))
             (n10 (fold (lambda (d t) (+ d (* 3 t))) 0 n3-list))
             (n2 (r-number->list n10 2)))
        (loop (if (palindrome? n2)
                (cons n10 results)
                results)
              (+ 1 i))))))

;; display final results, in bases 10, 2 and 3.
(for-each
  (lambda (n)
    (display
      (string-append (number->string n)
                     " in base 2: "
                     (r-number->string n 2)
                     " in base 3: "
                     (r-number->string n 3)))
    (newline))
  (get-series 6))
