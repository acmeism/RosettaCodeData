#lang racket
(define-values (1st 2nd 3rd) (values first second third))

(define-syntax-rule (?: x t f) (if (zero? x) f t))

(define (hash-ref2
         hsh# key-1 key-2
         #:fail-2 (fail-2 (λ () (error 'hash-ref2 "key-2:~a is not found in hash" key-2)))
         #:fail-1 (fail-1 (λ () (error 'hash-ref2 "key-1:~a is not found in hash" key-1))))
  (hash-ref (hash-ref hsh# key-1 fail-1) key-2 fail-2))

(define (VAM costs all-supply all-demand)
  (define (reduce-g/x g/x x#-- x x-v y y-v)
    (for/fold ((rv (?: x-v g/x (hash-remove g/x x))))
      (#:when (zero? y-v) ((k n) (in-hash x#--)) #:unless (zero? n))
      (hash-update rv k (curry remove y))))

  (define (cheapest-candidate/tie-break candidates)
    (define cand-max3 (3rd (argmax 3rd candidates)))
    (argmin 2nd (for/list ((cand candidates) #:when (= (3rd cand) cand-max3)) cand)))

  (let vam-loop
    ((res (hash))
     (supply all-supply)
     (g/supply
      (for/hash ((x (in-hash-keys all-supply)))
        (define costs#x (hash-ref costs x))
        (define key-fn (λ (g) (hash-ref costs#x g)))
        (values x (sort (hash-keys costs#x) < #:key key-fn #:cache-keys? #t))))
     (demand all-demand)
     (g/demand
      (for/hash ((x (in-hash-keys all-demand)))
        (define key-fn (λ (g) (hash-ref2 costs g x)))
        (values x (sort (hash-keys costs) < #:key key-fn #:cache-keys? #t)))))
    (cond
      [(and (hash-empty? supply) (hash-empty? demand)) res]
      [(or (hash-empty? supply) (hash-empty? demand)) (error 'VAM "Unbalanced supply / demand")]
      [else
       (define D
         (let ((candidates
                (for/list ((x (in-hash-keys demand)))
                  (match-define (hash-table ((== x) (and g#x (list g#x.0 _ ...))) _ ...) g/demand)
                  (define z (hash-ref2 costs g#x.0 x))
                  (match g#x
                    [(list _ g#x.1 _ ...) (list x z (- (hash-ref2 costs g#x.1 x) z))]
                    [(list _) (list x z z)]))))
           (cheapest-candidate/tie-break candidates)))

       (define S
         (let ((candidates
                (for/list ((x (in-hash-keys supply)))
                  (match-define (hash-table ((== x) (and g#x (list g#x.0 _ ...))) _ ...) g/supply)
                  (define z (hash-ref2 costs x g#x.0))
                  (match g#x
                    [(list _ g#x.1 _ ...) (list x z (- (hash-ref2 costs x g#x.1) z))]
                    [(list _) (list x z z)]))))
           (cheapest-candidate/tie-break candidates)))

       (define-values (d s)
         (let ((t>f? (if (= (3rd D) (3rd S)) (> (2nd S) (2nd D)) (> (3rd D) (3rd S)))))
           (if t>f? (values (1st D) (1st (hash-ref g/demand (1st D))))
               (values (1st (hash-ref g/supply (1st S))) (1st S)))))

       (define v (min (hash-ref supply s) (hash-ref demand d)))

       (define d-v (- (hash-ref demand d) v))
       (define s-v (- (hash-ref supply s) v))

       (define demand-- (?: d-v (hash-set demand d d-v) (hash-remove demand d)))
       (define supply-- (?: s-v (hash-set supply s s-v) (hash-remove supply s)))

       (vam-loop
        (hash-update res s (λ (h) (hash-update h d (λ (x) (+ v x)) 0)) hash)
        supply-- (reduce-g/x g/supply supply-- s s-v d d-v)
        demand-- (reduce-g/x g/demand demand-- d d-v s s-v))])))

(define (vam-solution-cost costs demand?cols solution)
  (match demand?cols
    [(? list? demand-cols)
     (for*/sum ((g (in-hash-keys costs)) (n (in-list demand-cols)))
       (* (hash-ref2 solution g n #:fail-2 0) (hash-ref2 costs g n)))]
    [(hash-table (ks _) ...) (vam-solution-cost costs (sort ks symbol<? solution))]))

(define (describe-VAM-solution costs demand sltn)
  (define demand-cols (sort (hash-keys demand) symbol<?))
  (string-join
   (map
    (curryr string-join "\t")
    `(,(map ~a (cons "" demand-cols))
      ,@(for/list ((g (in-hash-keys costs)))
          (cons (~a g) (for/list ((c demand-cols)) (~a (hash-ref2 sltn g c #:fail-2 "-")))))
      ()
      ("Total Cost:" ,(~a (vam-solution-cost costs demand-cols sltn)))))
   "\n"))

;; --------------------------------------------------------------------------------------------------
(let ((COSTS (hash 'W (hash 'A 16 'B 16 'C 13 'D 22 'E 17)
                   'X (hash 'A 14 'B 14 'C 13 'D 19 'E 15)
                   'Y (hash 'A 19 'B 19 'C 20 'D 23 'E 50)
                   'Z (hash 'A 50 'B 12 'C 50 'D 15 'E 11)))
      (DEMAND (hash 'A 30 'B 20 'C 70 'D 30 'E 60))
      (SUPPLY (hash 'W 50 'X 60 'Y 50 'Z 50)))
  (displayln (describe-VAM-solution COSTS DEMAND (VAM COSTS SUPPLY DEMAND))))
