#lang racket

(define list-partitions
  (match-lambda
    [(list) (list null)]
    [(and L (list _)) (list (list L))]
    [(list L ...)
     (for*/list
          ((i (in-range 1 (add1 (length L))))
           (r (in-list (list-partitions (drop L i)))))
        (cons (take L i) r))]))

(define digits->number (curry foldl (λ (dgt acc) (+ (* 10 acc) dgt)) 0))

(define partition-digits-to-numbers
  (let ((memo (make-hash)))
    (λ (dgts)
      (hash-ref! memo dgts
                 (λ ()
                   (map (λ (p) (map digits->number p))
                        (list-partitions dgts)))))))

(define (fold-sum-to-ns digits kons k0)
  (define (get-solutions nmbrs acc chain k)
    (match nmbrs
      [(list)
       (kons (cons acc (let ((niahc (reverse chain)))
                         (if (eq? '+ (car niahc)) (cdr niahc) niahc)))
             k)]
      [(cons a d)
       (get-solutions d (- acc a) (list* a '- chain)
                      (get-solutions d (+ acc a) (list* a '+ chain) k))]))
  (foldl (λ (nmbrs k) (get-solutions nmbrs 0 null k)) k0 (partition-digits-to-numbers digits)))

(define sum-to-ns/hash-promise
  (delay (fold-sum-to-ns
          '(1 2 3 4 5 6 7 8 9)
          (λ (a.s d) (hash-update d (car a.s) (λ (x) (cons (cdr a.s) x)) list))
          (hash))))

(module+ main
  (define S (force sum-to-ns/hash-promise))
  (displayln "Show all solutions that sum to 100")
  (pretty-print (hash-ref S 100))

  (displayln "Show the sum that has the maximum number of solutions (from zero to infinity*)")
  (let-values (([k-max v-max]
                (for/fold ((k-max #f) (v-max 0))
                          (([k v] (in-hash S)) #:when (> (length v) v-max))
                  (values k (length v)))))
    (printf "~a has ~a solutions~%" k-max v-max))

  (displayln "Show the lowest positive sum that can't be expressed (has no solutions),
 using the rules for this task")
  (for/first ((n (in-range 1 (add1 123456789))) #:unless (hash-has-key? S n)) n)

  (displayln "Show the ten highest numbers that can be expressed using the rules for this task")
  (take (sort (hash-keys S) >) 10))

(module+ test
  (require rackunit)
  (check-equal? (list-partitions null) '(()))
  (check-equal? (list-partitions '(1)) '(((1))))
  (check-equal? (list-partitions '(1 2)) '(((1) (2)) ((1 2))))
  (check-equal? (partition-digits-to-numbers '()) '(()))
  (check-equal? (partition-digits-to-numbers '(1)) '((1)))
  (check-equal? (partition-digits-to-numbers '(1 2)) '((1 2) (12))))
