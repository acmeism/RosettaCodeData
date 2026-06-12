#lang racket

(define (rand-seq n)
  (build-string n (lambda _ (string-ref "TGAC" (random 4)))))

(define (subsequence-indices full part)
  (let ((part-length (string-length part)) (full-length (string-length full)))
    (for/list ((i (- full-length part-length))
               #:when (for/and ((p part) (f (in-string full i))) (eq? p f)))
      (cons i (+ i part-length -1)))))

(define (report-sequence s (l 50))
  (string-join (for/list ((i (in-range 0 (string-length s) l)))
                 (format "~a: ~a" (~a #:width 4 i)
                         (substring s i (min (string-length s) (+ i l)))))
               "\n"))

(define (Bioinformatics/Subsequence (full (rand-seq 400)) (sub (rand-seq 4)))
  (printf "Indices of ~a in~%~a~%~a~%"
          sub (report-sequence full) (subsequence-indices full sub)))

(module+ main (for ((i 4)) (Bioinformatics/Subsequence)))
