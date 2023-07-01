#lang racket
(require racket/splicing)

(define (reverse-digits_10 N)
  (let inr ((n N) (m 0))
    (match n
      [0 m]
      [(app (curryr quotient/remainder 10) q r)
       (inr q (+ r (* 10 m)))])))

(define (palindrome?_10 n)
  (= n (reverse-digits_10 n)))

;; hash of integer? -> one of 'seed 'related #f
(splicing-let ((memo# (make-hash)))
  (define (generate-lychrel?-chain i i-rev n acc)
    (cond
      [(zero? n) ; out of steam
       (cons 'seed acc)]
      [else
       (let* ((i+ (+ i i-rev)) (i+-rev (reverse-digits_10 i+)))
         (cond
           [(= i+ i+-rev) ; palindrome breaks the chain
            (cons #f acc)]
           [(eq? 'related (hash-ref memo# i+ #f)) ; deja vu
            (cons 'related acc)]
           [else ; search some more
            (generate-lychrel?-chain i+ i+-rev (sub1 n) (cons i+ acc))]))]))

  ;; returns 'seed, 'related or #f depending of the Lychrel-ness of a number
  (define (lychrel-number? i #:n (n 500))
    (match (hash-ref memo# i 'unfound)
      ['unfound
       (match (generate-lychrel?-chain i (reverse-digits_10 i) n null)
         [(cons 'related chain) 'related]
         [(cons (and seed (or (and 'seed (app (λ (_) 'related) related?))
                              (and #f (app (λ (_) #f) related?))))
                chain)
          (for ((c (in-list chain))) (hash-set! memo# c related?))
          (hash-set! memo# i seed)
          seed])]
      [seed/related/false seed/related/false])))

(module+ main
  (define-values (seeds/r n-relateds palindromes/r)
    (for/fold ((s/r null) (r 0) (p/r null))
              ((i (in-range 1 (add1 10000))))
      (define lych? (lychrel-number? i))
      (define p/r+ (if (and lych? (palindrome?_10 i)) (cons (list i (list lych?)) p/r) p/r))
      (match lych?
        ['seed (values (cons i s/r) r p/r+)]
        ['related (values s/r (add1 r) p/r+)]
        [#f (values s/r r p/r+)])))

  (printf #<<EOS
Seed Lychrel numbers:        ~a count:~a
Related Lychrel numbers:     count:~a
Palindromic Lychrel numbers: ~a~%
EOS
          (reverse seeds/r) (length seeds/r) n-relateds (reverse palindromes/r)))
