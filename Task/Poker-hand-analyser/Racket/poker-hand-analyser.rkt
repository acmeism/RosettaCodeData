#lang racket
(require (only-in srfi/1 car+cdr))

;;; --------------------------------------------------------------------------------------------------
;;; The analyser is first... the rest of it is prettiness surrounding strings and parsing!
;;; --------------------------------------------------------------------------------------------------
;; (cons f _) and (cons _ s) appear too frequently in patterns to not factor out
(define-match-expander F._ (λ (stx) (syntax-case stx () [(_ f) #'(cons f _)])))
(define-match-expander _.S (λ (stx) (syntax-case stx () [(_ s) #'(cons _ s)])))

;; Matches are easier when the cards are lined up by face: and I always put the cards in my hand with
;; the highest card on the left (should I be telling this?)... anyway face<? is written to leave high
;; cards on the left. There is no need to sort by suit, flushes are all-or-nothing
(define (face-sort hand)
  (sort hand (match-lambda** [(_ 'joker) #f] [('joker _) #t] [((F._ f1) (F._ f2)) (> f1 f2)])))

;; even playing poker for money, I never managed to consistently determine what effect jokers were
;; having on my hand... so I'll do an exhaustive search of what's best!
;;
;; scoring hands allows us to choose a best value for joker(s)
;; hand-names provides an order (and therefore a score) for each of the available hands
(define hand-names (list 'five-of-a-kind 'straight-flush 'four-of-a-kind 'full-house 'flush 'straight
                         'three-of-a-kind 'two-pair 'one-pair 'high-card))

(define hand-order# (for/hash ((h hand-names) (i (in-range (add1 (length hand-names)) 0 -1)))
                      (values h i)))
;; The score of a hand is (its order*15^5)+(first tiebreaker*15^4)+(2nd tiebreaker*15^3)...
;; powers of 15 because we have a maxmium face value of 14 (ace) -- even though there are 13 cards
;; in a suit.
(define (calculate-score analysis)
  (define-values (hand-name tiebreakers) (car+cdr analysis))
  (for/sum ((n (in-naturals)) (tb (cons (hash-ref hand-order# hand-name -1) tiebreakers)))
    (* tb (expt 15 (- 5 n)))))

;; score hand produces an analysis of a hand (which can then be returned to analyse-sorted-hand,
;; and a score that can be maximised by choosing the right jokers.
(define (score-hand hand . jokers) ; gives an orderable list of hands with tiebreakers
  (define analysis (analyse-sorted-hand (face-sort (append jokers hand))))
  (cons analysis (calculate-score analysis)))

;; if we have two (or more) jokers, they will be consumed by the recursive call to
;; analyse-sorted-hand score-hand
(define all-cards/promise (delay (for*/list ((f (in-range 2 15)) (s '(h d s c))) (cons f s))))

(define (best-jokered-hand cards) ; we've lost the first joker from cards
  (define-values (best-hand _bhs)
    (for*/fold ((best-hand #f) (best-score 0))
      ((joker (in-list (force all-cards/promise)))
       (score (in-value (score-hand cards joker)))
       #:when (> (cdr score) best-score))
      (car+cdr score)))

  best-hand)

;; we can abbreviate 2/3/4/5-of-a-kind 2-pair full-house with 2 and 3
(define-match-expander F*2 (λ (stx) (syntax-case stx () [(_ f) #'(list (F._ f) (F._ f))])))
(define-match-expander F*3 (λ (stx) (syntax-case stx () [(_ f) #'(list (F._ f) (F._ f) (F._ f))])))

;; note that flush? is cheaper to calculate than straight?, so do it first when we test for
;; straight-flush
(define flush?
  (match-lambda [(and `(,(_.S s) ,(_.S s) ,(_.S s) ,(_.S s) ,(_.S s)) `(,(F._ fs) ...)) `(flush ,@fs)]
                [_ #f]))

(define straight?
  (match-lambda
    ;; '(straight 5) puts this at the bottom of the pile w.r.t the ordering of straights
    [`(,(F._ 14) ,(F._ 5) ,(F._ 4) ,(F._ 3) ,(F._ 2))                                   '(straight 5)]
    [`(,(F._ f5) ,(F._ f4) ,(F._ f3) ,(F._ f2) ,(F._ f1))
     (and (= f1 (- f5 4)) (< f1 f2 f3 f4 f5)                                       `(straight ,f5))]))

(define analyse-sorted-hand
  (match-lambda
    [(list 'joker cards ...)                                                (best-jokered-hand cards)]
    [`(,@(F*3 f) ,@(F*2 f))                                                      `(five-of-a-kind ,f)]
    ;; get "top" from the straight. a the top card of the flush when there is a (straight 5) will
    ;; be the ace ... putting it in the wrong place for the ordering.
    [(and (? flush?) (app straight? (list 'straight top _ ...)))               `(straight-flush ,top)]
    [(or `(,@(F*2 f) ,@(F*2 f) ,_) `(,_ ,@(F*2 f) ,@(F*2 f)))                    `(four-of-a-kind ,f)]
    [(or `(,@(F*3 fh) ,@(F*2 fl)) `(,@(F*2 fh) ,@(F*3 fl)))                     `(full-house ,fh, fl)]
    [(app flush? (and rv (list 'flush _ ...)))                                                     rv]
    [(app straight? (and rv (list 'straight _ ...)))                                               rv]
    ;; pairs and threes may be padded to the left, middle and right with tie-breakers; the lists of
    ;; which we will call l, m and r, respectively (four and 5-of-a-kind don't need tiebreaking,
    ;; they're well hard!)
    [`(,(F._ l) ... ,@(F*3 f) ,(F._ r) ...)                             `(three-of-a-kind ,f ,@l ,@r)]
    [`(,(F._ l) ... ,@(F*2 f1) ,(F._ m) ... ,@(F*2 f2) ,(F._ r) ...)  `(two-pair ,f1 ,f2 ,@l ,@m ,@r)]
    [`(,(F._ l) ... ,@(F*2 f) ,(F._ r) ...)                                    `(one-pair ,f ,@l ,@r)]
    [`(,(F._ f) ...)                                                                 `(high-card ,@f)]
    [hand                                                                (error 'invalid-hand hand)]))

(define (analyse-hand/string hand-string)
  (analyse-sorted-hand (face-sort (string->hand hand-string))))

;;; --------------------------------------------------------------------------------------------------
;;; Strings to cards, cards to strings -- that kind of thing
;;; --------------------------------------------------------------------------------------------------
(define suit->unicode (match-lambda ('h "♥") ('d "♦") ('c "♣") ('s "♠") (x x)))

(define unicode->suit (match-lambda ("♥" 'h) ("♦" 'd) ("♣" 'c) ("♠" 's) (x x)))

(define (face->number f)
  (match (string-upcase f)
    ["T" 10] ["J" 11] ["Q" 12] ["K" 13] ["A" 14] [(app string->number (? number? n)) n] [else 0]))

(define number->face (match-lambda (10 "T") (11 "J") (12 "Q") (13 "K") (14 "A") ((app ~s x) x)))

(define string->card
  (match-lambda
    ("joker" 'joker)
    ((regexp #px"^(.*)(.)$" (list _ (app face->number num) (app unicode->suit suit)))
     (cons num suit))))

(define (string->hand str)
  (map string->card (regexp-split #rx" +" (string-trim str))))

(define card->string
  (match-lambda ['joker "[]"]
                [(cons (app number->face f) (app suit->unicode s)) (format "~a~a" f s)]))

(define (hand->string h)
  (string-join (map card->string h) " "))

;; used for both testing and output
(define e.g.-hands
  (list " 2♥  2♦ 2♣ k♣  q♦" " 2♥  5♥ 7♦ 8♣  9♠" " a♥  2♦ 3♣ 4♣  5♦" "10♥  j♦ q♣ k♣  a♦"
        " 2♥  3♥ 2♦ 3♣  3♦" " 2♥  7♥ 2♦ 3♣  3♦" " 2♥  7♥ 7♦ 7♣  7♠" "10♥  j♥ q♥ k♥  a♥"
        " 4♥  4♠ k♠ 5♦ 10♠" " q♣ 10♣ 7♣ 6♣  4♣"

        " joker  2♦  2♠  k♠  q♦"     "  joker  5♥  7♦  8♠  9♦"    "  joker  2♦  3♠  4♠  5♠"
        "  joker  3♥  2♦  3♠  3♦"    "  joker  7♥  2♦  3♠  3♦"    "  joker  7♥  7♦  7♠  7♣"
        "  joker  j♥  q♥  k♥  A♥"    "  joker  4♣  k♣  5♦ 10♠"    "  joker  k♣  7♣  6♣  4♣"
        "  joker  2♦  joker  4♠  5♠" "  joker  Q♦  joker  A♠ 10♠" "  joker  Q♦  joker  A♦ 10♦"
        "  joker  2♦  2♠  joker  q♦"))

;;; --------------------------------------------------------------------------------------------------
;;; Main and test modules
;;; --------------------------------------------------------------------------------------------------
(module+ main
  (define scored-hands
    (for/list ((h (map string->hand e.g.-hands)))
      (define-values (analysis score) (car+cdr (score-hand h)))
      (list h analysis score)))

  (for ((a.s (sort scored-hands > #:key third)))
    (match-define (list (app hand->string h) a _) a.s)
    (printf "~a: ~a ~a" h (~a (first a) #:min-width 15) (number->face (second a)))
    (when (pair? (cddr a)) (printf " [tiebreak: ~a]" (string-join (map number->face (cddr a)) ", ")))
    (newline)))

(module+ test
  (require rackunit)
  (let ((e.g.-strght-flsh '((14 . h) (13 . h) (12 . h) (11 . h) (10 . h))))
    (check-match (straight? e.g.-strght-flsh) '(straight 14))
    (check-match (flush? e.g.-strght-flsh) '(flush 14 13 12 11 10))
    (check-match e.g.-strght-flsh (and (? flush?) (app straight? (list 'straight top _ ...)))))

  (define expected-results
    '((three-of-a-kind 2 13 12)
      (high-card 9 8 7 5 2) (straight 5) (straight 14) (full-house 3 2) (two-pair 3 2 7)
      (four-of-a-kind 7) (straight-flush 14) (one-pair 4 13 10 5) (flush 12 10 7 6 4)
      (three-of-a-kind 2 13 12) (straight 9) (straight 6) (four-of-a-kind 3) (three-of-a-kind 3 7 2)
      (five-of-a-kind 7) (straight-flush 14) (one-pair 13 10 5 4) (flush 14 13 7 6 4) (straight 6)
      (straight 14) (straight-flush 14) (four-of-a-kind 2)))
  (for ((h e.g.-hands) (r expected-results)) (check-equal? (analyse-hand/string h) r)))
