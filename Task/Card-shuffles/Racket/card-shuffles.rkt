#lang typed/racket
;; ---------------------------------------------------------------------------------------------------
;; Types and shuffle builder

;; A cutter separates the deck into more than one sub-decks -- the last one of these is "left in the
;; hand", as per the overhand shuffle (since it is the last strip to be stripped). The riffler
;; indicates this in its second (non-null) return value
(define-type (Cutter A) (-> (Listof A) (Pair (Listof A) (Listof (Listof A)))))
;; A riffler takes taking hand and the cut deck parts. returns a newly merged deck in the "taking"
;; hand and the deck left in the "giving" hand. The shuffler will keep taking,
;; until there is nothing to give
(define-type (Riffler A) ((Listof A) (Listof A) (Listof A) * -> (Values (Listof A) (Listof A))))
;; "The shuffler will keep taking until there is nothing to give"... and will do this
;; the number of times specified by its second argument
(define-type (Shuffler A) ((Listof A) Natural -> (Listof A)))

;; makes a shuffler from the cutter and the riffler
(: shuffler-composer (All (A) (Cutter A) (Riffler A) -> (Shuffler A)))
(define ((shuffler-composer cut riffle) deck n)
  (: one-shuffle : (Listof A) -> (Listof A))
  (define (one-shuffle g)
    (let: shuff ((t : (Listof A) null) (g : (Listof A) g))
      (let-values (((t+ g-) (apply riffle t (cut g))))
        (if (null? g-) t+ (shuff t+ g-)))))
  (for/fold : (Listof A) ((d deck)) ((i (in-range n)))
    (one-shuffle d)))

;; convenient wrapper around the above (otherwise we'd need the inst every time we
;; wanted to compose a cut and a riffle
(define-syntax-rule (define-composed-shuffler s (c r))
  (define: (A) (s [x : (Listof A)] [n : Natural]) : (Listof A)
    ((#{shuffler-composer @ A} c r) x n)))

;; ---------------------------------------------------------------------------------------------------
;; Overhand (and, as far as I can tell, Indian)
(: overhand-cutter (All (A) (Cutter A)))
(: overhand-riffler (All (A) (Riffler A)))

(define (overhand-cutter l)
  (define spl (match (length l) [0 0] [1 1] [len (add1 (random (sub1 len)))]))
  (list (take l spl) (drop l spl)))

(define (overhand-riffler t p1 . rest)
  (values (append p1 t) (append* rest)))

(define-composed-shuffler overhand-shuffle (overhand-cutter overhand-riffler))

;; ---------------------------------------------------------------------------------------------------
;; Riffle (with optional "drop" where two cards are riffled
(: half-deck-cutter (All (A) (Cutter A)))
(: mk-riffle-riffler (All (A) ((#:p-drop Nonnegative-Real) -> (Riffler A))))

(define (half-deck-cutter l)
  (define spl (quotient (length l) 2))
  (list (take l spl) (drop l spl)))

;; All the "reverse"ing is to emulate a physical shuffle... it's not
;; necessary for the "randomising" effect (which there isn't really on
;; a pure riffle anyway)
;;
;; Additional complexity added by ability to drop cards on both taking
;; and giving hand
(define ((mk-riffle-riffler #:p-drop (p-drop 0)) t p1 . rest)
  (define g-/rev
    (let R : (Listof A)
      ((r1 : (Listof A) p1)
       (r2 : (Listof A) (append* rest))
       (rv : (Listof A) t)) ; although t should normaly be null
      (define drop-t? (< (random) p-drop))
      (define drop-g? (< (random) p-drop))
      (match* (r1 r2 drop-t? drop-g?)
        [((list) (app reverse 2r) _ _) (append 2r rv)]
        [((app reverse 1r) (list) _ _) (append 1r rv)]
        [((list a1.1 a1.2 d1 ...) (list a2.1 a2.2 d2 ...) #t #t)
         (R d1 d2 (list* a2.2 a2.1 a1.2 a1.1 rv))]
        [((list a1.1 a1.2 d1 ...) (list a2.1 d2 ...) #t _)
         (R d1 d2 (list* a2.1 a1.2 a1.1 rv))]
        [((list a1.1 d1 ...) (list a2.1 a2.2 d2 ...) _ #t)
         (R d1 d2 (list* a2.2 a2.1 a1.1 rv))]
        [((list a1.1 d1 ...) (list a2.1 d2 ...) _ _)
         (R d1 d2 (list* a2.1 a1.1 rv))])))
  (values (reverse g-/rev) null))

(define-composed-shuffler pure-riffle-shuffle (half-deck-cutter (mk-riffle-riffler)))
(define-composed-shuffler klutz-riffle-shuffle (half-deck-cutter (mk-riffle-riffler #:p-drop 0.5)))

;; ---------------------------------------------------------------------------------------------------
;; Pile Shuffle
;; Also Wash Shuffle, if pile-height=1 and random-gather=#t
(: mk-pile-cutter (All (A) (#:pile-height Positive-Integer -> (Cutter A))))
(: mk-pile-riffler (All (A) ((#:random-gather? Boolean) -> (Riffler A))))

(define ((mk-pile-cutter #:pile-height pile-height) l)
  (define len-l (length l))
  (define n-piles (add1 (quotient (sub1 len-l) pile-height)))
  (: make-pile (Integer -> (Listof A)))
  (define (make-pile n)
    (for/list : (Listof A) ((i (in-range n len-l n-piles)))
      (list-ref l i)))
  (define pile-0 (make-pile 0))
  (define piles-ns (for/list : (Listof (Listof A)) ((n (in-range 1 n-piles))) (make-pile n)))
  (list* pile-0 piles-ns))

(define ((mk-pile-riffler #:random-gather? (random-gather? #f)) t p1 . rest)
  (: piles (Listof (Listof A)))
  (define piles (cons p1 rest))
  (define gather (if random-gather? (shuffle piles) piles))
  (values (append* (cons t (if random-gather? (shuffle piles) piles))) null))

(define-composed-shuffler 4-high-pile-shuffle ((mk-pile-cutter #:pile-height 4) (mk-pile-riffler)))
(define-composed-shuffler wash-pile-shuffle
  ((mk-pile-cutter #:pile-height 1) (mk-pile-riffler #:random-gather? #t)))

;; ---------------------------------------------------------------------------------------------------
(define unshuffled-pack
  (for*/list : (Listof String)
    ((s '(♥ ♦ ♣ ♠))
     (f '(2 3 4 5 6 7 8 9 T J Q K A)))
    (format "~a~a" f s)))

;; ---------------------------------------------------------------------------------------------------
;; TEST/OUTPUT
(module+ test
  (require typed/rackunit)
  (check-equal? (overhand-shuffle null 1) null)
  (check-equal? (overhand-shuffle '(a) 1) '(a))
  (check-equal? (overhand-shuffle '(a b) 1) '(b a))
  (check-equal? (pure-riffle-shuffle '(1 2 3 4) 1) '(1 3 2 4))
  (error-print-width 80))

(module+ main
  (printf "deck (original order):          ~.a~%" unshuffled-pack)
  (printf "overhand-shuffle (2 passes):    ~.a~%" (overhand-shuffle unshuffled-pack 2))
  (printf "overhand-shuffle (1300 passes): ~.a~%" (overhand-shuffle unshuffled-pack 1300))
  (printf "riffle: pure                    ~.a~%" (pure-riffle-shuffle unshuffled-pack 1))
  (printf "riffle: klutz                   ~.a~%" (klutz-riffle-shuffle unshuffled-pack 1))
  (printf "4-high piles:                   ~.a~%" (4-high-pile-shuffle unshuffled-pack 1))
  (printf "4-high piles (7 passes):        ~.a~%" (4-high-pile-shuffle unshuffled-pack 7))
  (printf "4-high piles (7 passes again):  ~.a~%" (4-high-pile-shuffle unshuffled-pack 7))
  (printf "wash piles:                     ~.a~%" (wash-pile-shuffle unshuffled-pack 1))
  ;; Or there is always the built-in shuffle:
  (printf "shuffle:                        ~.a~%" (shuffle unshuffled-pack)))
