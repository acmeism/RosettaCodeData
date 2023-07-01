#lang racket
;; Tim Brown 2014-09-15
(define (sort-standing stndg#)
  (sort (hash->list stndg#) > #:key cdr))

(define (hash-update^2 hsh key key2 updater2 dflt2)
  (hash-update hsh key (λ (hsh2) (hash-update hsh2 key2 updater2 dflt2)) hash))

(define all-standings
  (let ((G '((a b) (a c) (a d) (b c) (b d) (c d)))
        (R '((3 0) (1 1) (0 3))))
    (map
     sort-standing
     (for*/list ((r1 R) (r2 R) (r3 R) (r4 R) (r5 R) (r6 R))
       (foldr (λ (gm rslt h)
                (hash-update
                 (hash-update h (second gm) (λ (n) (+ n (second rslt))) 0)
                 (first gm) (curry + (first rslt)) 0))
              (hash) G (list r1 r2 r3 r4 r5 r6))))))

(define histogram
  (for*/fold ((rv (hash)))
    ((stndng (in-list all-standings)) (psn (in-range 0 4)))
    (hash-update^2 rv (add1 psn) (cdr (list-ref stndng psn)) add1 0)))

;; Generalised histogram printing functions...
(define (show-histogram hstgrm# captions)
  (define (min* a b)
    (if (and a b) (min a b) (or a b)))
  (define-values (position-mn position-mx points-mn points-mx)
    (for*/fold ((mn-psn #f) (mx-psn 0) (mn-pts #f) (mx-pts 0))
      (((psn rw) (in-hash hstgrm#)))
      (define-values (min-pts max-pts)
        (for*/fold ((mn mn-pts) (mx mx-pts)) ((pts (in-hash-keys rw)))
          (values (min* pts mn) (max pts mx))))
      (values (min* mn-psn psn) (max mx-psn psn) min-pts max-pts)))

  (define H
    (let ((lbls-row# (for/hash ((i (in-range points-mn (add1 points-mx)))) (values i i))))
      (hash-set hstgrm# 'thead lbls-row#)))

  (define cap-col-width (for/fold ((m 0)) ((v (in-hash-values captions))) (max m (string-length v))))

  (for ((plc (in-sequences
              (in-value 'thead)
              (in-range position-mn (add1 position-mx)))))
    (define cnts (for/list ((pts (in-range points-mn (add1 points-mx))))
                   (~a #:align 'center #:width 3 (hash-ref (hash-ref H plc) pts 0))))
    (printf "~a ~a~%"
            (~a (hash-ref captions plc (curry format "#~a:")) #:width cap-col-width)
            (string-join cnts "  "))))

(define captions
  (hash 'thead "POINTS:"
        1 "1st Place:"
        2 "2nd Place:"
        3 "Sack the manager:"
        4 "Sack the team!"))

(show-histogram histogram captions)
