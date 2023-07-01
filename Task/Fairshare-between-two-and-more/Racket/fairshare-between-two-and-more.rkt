#lang racket

(define (Thue-Morse base)
  (letrec ((q/r (curryr quotient/remainder base))
           (inner (λ (n (s 0))
                    (match n
                      [0 (modulo s base)]
                      [(app q/r q r) (inner q (+ s r))]))))
    inner))

(define (report-turns B n)
  (printf "Base:\t~a\t~a~%" B (map (Thue-Morse B) (range n))))

(define (report-stats B n)
  (define TM (Thue-Morse B))
  (define h0 (for/hash ((b B)) (values b 0)))
  (define d (for/fold ((h h0)) ((i n)) (hash-update h (TM i) add1 0)))
  (define d′ (for/fold ((h (hash))) (([k v] (in-hash d))) (hash-update h v add1 0)))
  (define d′′ (hash-map d′ (λ (k v) (format "~a people have ~a turn(s)" v k))))
  (printf "Over ~a turns for ~a people:~a~%" n B (string-join d′′ ", ")))

(define (Fairshare-between-two-and-more)
  (report-turns 2 25)
  (report-turns 3 25)
  (report-turns 5 25)
  (report-turns 11 25)
  (newline)
  (report-stats 191 50000)
  (report-stats 1377 50000)
  (report-stats 49999 50000)
  (report-stats 50000 50000)
  (report-stats 50001 50000))

(module+ main
  (Fairshare-between-two-and-more))
