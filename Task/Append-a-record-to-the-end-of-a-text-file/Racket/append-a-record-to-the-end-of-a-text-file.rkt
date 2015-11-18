#lang racket

(define sample1
  '("jsmith" "x" 1001 1000
    ("Joe Smith" "Room 1007" "(234)555-8917" "(234)555-0077" "jsmith@rosettacode.org")
    "/home/jsmith" "/bin/bash"))

(define sample2
  '("jdoe" "x" 1002 1000
    ("Jane Doe" "Room 1004" "(234)555-8914" "(234)555-0044" "jdoe@rosettacode.org")
    "/home/jdoe" "/bin/bash"))

(define sample3
  '("xyz" "x" 1003 1000
    ("X Yz" "Room 1003" "(234)555-8913" "(234)555-0033" "xyz@rosettacode.org")
    "/home/xyz" "/bin/bash"))

(define passwd-file "sexpr-passwd")

(define (write-passwds mode . ps)
  (with-output-to-file passwd-file #:exists mode
    (λ() (for ([p (in-list ps)]) (printf "~s\n" p)))))

(define (lookup username)
  (with-input-from-file passwd-file
    (λ() (for/first ([p (in-producer read eof)]
                     #:when (equal? username (car p)))
           p))))

(printf "Creating file with two sample records.\n")
(write-passwds 'replace sample1 sample2)

(printf "Appending third sample.\n")
(write-passwds 'append sample3)

(printf "Looking up xyz in current file:\n=> ~s\n" (lookup "xyz"))
