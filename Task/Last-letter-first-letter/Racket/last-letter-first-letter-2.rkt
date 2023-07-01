#lang racket
(require "pokemon-names.rkt")

;;; Some fundamentals... finding the first (henceforth referred to as "a") and last ("z")
;;; letters of a word can be computationally intensive... look at symbol->word, and you'll
;;; see that when we have to deal with a name like: "Mime Jr.", the last alphabetic letter
;;; is not the last character. And the first and last characters (at least) have to be
;;; case-normalised so they can be compared with char=? (it's not particulary helpful to
;;; map them down to integer character codes; we'll want to see them for debugging).
(define-struct word (sym char-a char-z) #:prefab)

;;; names are input as symbols both for ease of comparsion, and because it's easier to type
(define (symbol->word sym)
  (let* ((str (symbol->string sym))
         (chrs (string->list str))
         (fst (for/first ((c chrs) #:when (char-alphabetic? c)) (char-downcase c)))
         (lst (for/last ((c chrs) #:when (char-alphabetic? c)) (char-downcase c))))
    (make-word sym fst lst)))

;;; We're sometimes not interested in debugging a chain of; just in knowing how long it is
;;; and what its extreme characters are. This does the trick.
(define (summarise-chain c)
  (format "(~a.~a.~a)" (word-char-a (first c)) (sub1 (length c)) (word-char-z (last c))))

;; Test the above (run `raco test last_letter-first_letter-common.rkt`)
(define-syntax-rule (hash-set-or-remove hsh key val remove-pred?)
  (let ((v val))
    (if (remove-pred? v)
        (hash-remove hsh key)
        (hash-set hsh key v))))

(define-syntax-rule (find-a-in-chain-pool chains a dont-match-sym)
  (for/first ((c chains)
              (i (in-naturals)) ;; usually need an index for regenerating chains pool
              ;; a word can only exist in one chain, so this compares chains' identities
              #:unless (eq? (word-sym (first c)) dont-match-sym)
              #:when (char=? (word-char-a (first c)) a))
    (cons i c)))

(define-syntax-rule (copy-list-ignoring-indices lst i1 i2)
  (for/list ((idx (in-naturals))
             (e (in-list lst))
             #:unless (= idx i1)
             #:unless (= idx i2))
    e))

;; Simple ... find a chain that can be put on the end of c... append it, and
;; reiterate
(define (append-ab..bz-chains chain chain-idx chains)
  (let* ((a1.chain-a (find-a-in-chain-pool chains (word-char-z (last chain)) (word-sym (first chain)))))
    (and a1.chain-a
         (let ((a1.chain-idx (first a1.chain-a))
               (a1.chain-chain (rest a1.chain-a)))
           (cons (append chain a1.chain-chain)
                 (copy-list-ignoring-indices chains chain-idx a1.chain-idx))))))

;; If chain has an a..a loop in it, then we see if we can take that loop, and
;; place it in a longer chain at a point where a is used.
;;
;; `chain` is the shorter chain containing the loop
(define (merge-chain-into-chain-accepting-a..a-in-chain chain chain-idx chains)
  ;; for a..a loops in chain, returns a hash from the looped char, to the longest
  ;; found loop
  (define (find-a..a-loops chain)
    (let ((chain-length (length chain)))
      (for*/fold
          ((hsh (hash)))
        ((sub-range-start (in-range chain-length))
         (aa (in-value (word-char-a (list-ref chain sub-range-start))))
         (sub-range-end (in-range sub-range-start chain-length))
         #:when (eq? aa (word-char-z (list-ref chain sub-range-end)))
         (range-length (in-value (add1 (- sub-range-end sub-range-start)))))
        (hash-update
         hsh aa
         (lambda (longest-range)
           (if (and longest-range (> (third longest-range) range-length))
               longest-range
               (list sub-range-start sub-range-end range-length)))
         #f))))

  (let* ((chain-first-name (word-sym (first chain)))
         (chain-length (length chain))
         (a..a-list (sort (hash->list (find-a..a-loops chain)) > #:key third)))
    (for*/first (((chain2 chain2-idx) (in-parallel (in-list chains) (in-naturals)))
                 #:unless (eq? chain-first-name (word-sym (car chain2)))
                 (chain2-length (in-value (length chain2)))
                 #:when (>= chain2-length chain-length) ; only move the largest a..a-subchain into a larger chain
                 (a..a (in-list a..a-list))
                 ((insertion-point-word insertion-point-idx) (in-parallel (in-list chain2) (in-naturals)))
                 #:when (eq? (car a..a) (word-char-a insertion-point-word)))
      (let* ((new-chain (append (take chain (second a..a)) (drop chain (add1 (third a..a)))))
             (a..a-chain (take (drop chain (second a..a)) (fourth a..a)))
             (new-chain2 (append (take chain2 insertion-point-idx) a..a-chain (drop chain2 insertion-point-idx))))
        (let ((new-chains (copy-list-ignoring-indices chains chain-idx chain2-idx)))
          (if (null? new-chain) (cons new-chain2 new-chains)
              (cons new-chain (cons new-chain2 new-chains))))))))

;; this is a bit more combinatorially intensive... for all c2, substitute a
;; subrange in c2 that is longer than an equivalent subrange in c
(define (merge-subranges-of-chains-into-chain chain chain-idx chains)
  (let ((chain-first-name (word-sym (first chain)))
        (chain-length (length chain))
        (chain-first-a (word-char-a (first chain)))
        (chain-last-z (word-char-z (last chain))))
    (for*/first ; try to replace a subrange in c2 with c
        (((chain2 chain2-idx) (in-parallel (in-list chains) (in-naturals)))
         (chain2-length (in-value (length chain2)))
         #:unless (eq? chain-first-name (word-sym (car chain2)))
         (c2-sub-range-start (in-range chain2-length))
         (c2-sub-range-end (in-range c2-sub-range-start
                                     (min chain2-length (+ c2-sub-range-start chain-length))))
         #:unless (and (= c2-sub-range-start 0) (= c2-sub-range-end (sub1 chain2-length)))
         #:when (or (zero? c2-sub-range-start)
                    (eq? (word-char-a (list-ref chain2 c2-sub-range-start))
                         chain-first-a))
         #:when (or (= (sub1 chain2-length) c2-sub-range-end)
                    (eq? (word-char-z (list-ref chain2 c2-sub-range-end))
                         chain-last-z))
         (c2-sub-range-len (in-value (add1 (- c2-sub-range-end c2-sub-range-start))))
         #:when (> chain-length c2-sub-range-len)
         (c2-sub-range (in-value (take (drop chain2 c2-sub-range-start) c2-sub-range-len)))
         (new-c2 (in-value (append (take chain2 c2-sub-range-start)
                                   chain
                                   (drop chain2 (add1 c2-sub-range-end))))))
      (cons c2-sub-range ; put the subrange back into the chains pool
            (cons new-c2 ; put the modified onto the chains pool
                  (copy-list-ignoring-indices chains chain-idx chain2-idx))))))

(define (longest-chain/constructive names #:known-max (known-max +inf.0))
  (define names-list (map symbol->word names))

  (define (link-chains chains)
    (let
        ((new-chains
          (for*/first
              (((chain chain-idx) (in-parallel (in-list chains) (in-naturals)))
               (new-chains
                (in-value
                 (or
                  (append-ab..bz-chains chain chain-idx chains)
                  (merge-chain-into-chain-accepting-a..a-in-chain chain chain-idx chains)
                  (merge-subranges-of-chains-into-chain chain chain-idx chains))))
               #:when new-chains)
            new-chains)))
      (if new-chains (link-chains new-chains) chains)))

  (define (keep-trying
           (run-count 0)
           (linked-chains (link-chains (map list (shuffle names-list))))
           (previous-best null)
           (previous-best-length 0)
           (this-run-best-length #f))
    (let* ((longest-chain (argmax length linked-chains))
           (longest-chain-len (length longest-chain))
           (new-best? (< previous-best-length longest-chain-len))
           (best-length (if new-best? longest-chain-len previous-best-length))
           (best (if new-best? longest-chain previous-best)))
      (when new-best? (newline)
        (displayln (list (map word-sym longest-chain) longest-chain-len))
        (flush-output))
      (if (and new-best? (>= best-length known-max))
          (displayln "terminating: known max reached or exceeded")
          (begin
            (when (zero? (modulo (add1 run-count) 250)) (eprintf ".") (flush-output (current-error-port)))
            (if (= run-count 1000)
                (keep-trying 0 (link-chains (map list (shuffle names-list))) best best-length 0)
                (let ((sorted-linked-chains (sort linked-chains #:key length >)))
                  (keep-trying (if new-best? 0 (add1 run-count))
                               (link-chains
                                (cons (car sorted-linked-chains)
                                      (map list (shuffle (apply append (cdr sorted-linked-chains))))))
                               best best-length
                               (and this-run-best-length
                                    (if new-best? #f
                                        (if (< this-run-best-length longest-chain-len)
                                            (begin (eprintf ">~a" longest-chain-len)
                                                   (flush-output (current-error-port))
                                                   longest-chain-len)
                                            this-run-best-length))))))))))
  (keep-trying))

(time (longest-chain/constructive names-70 #:known-max 23))
(longest-chain/constructive names-646)
