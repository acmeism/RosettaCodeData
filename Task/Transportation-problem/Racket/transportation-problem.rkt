#lang typed/racket
;; {{trans|Java}}
(define-type (V2 A) (Vectorof (Vectorof A)))
(define-type VI (Vectorof Integer))
(define-type V2R (V2 Real))
(define-type Q (U 'ε Integer))
(define ε 'ε)
(struct Shipment ([qty : Q] [cost/unit : Real] [r : Integer] [c : Integer]))
(define-type Shipment/? (Option Shipment))
(define-type V2-Shipment/? (V2 Shipment/?))
(define-type Shipment/?s (Listof Shipment/?))
(define-type Shipments (Listof Shipment))

(: Q+ (Q Q -> Q))
(: Q- (Q Q -> Q))
(: Q<? (Q Q -> Boolean))
(: Q-zero? (Q -> Boolean))
(: Q-unary- (Q -> Q))
(: Q*R (Q Real -> Real))

(define Q+ (match-lambda** [('ε 0) ε] [(0 'ε) ε] [('ε 'ε) ε] [('ε x) x] [(x 'ε) x]
                           [((? integer? x) (? integer? y)) (+ x y)]))

(define Q<? (match-lambda** [('ε 0) #f] [(0 'ε) #t] [('ε 'ε) #f] [('ε x) #t] [(x 'ε) #f]
                            [((? integer? x) (? integer? y)) (< x y)]))

(define Q- (match-lambda** [('ε 0) ε] [(0 'ε) ε] [('ε 'ε) 0] [('ε (? integer? x)) (- x)] [(x 'ε) x]
                           [((? integer? x) (? integer? y)) (- x y)]))

(define Q-unary- (match-lambda ['ε ε] [(? integer? x) (- x)]))

(define Q-zero? (match-lambda ['ε #f] [(? integer? x) (zero? x)]))

(define Q*R (match-lambda** [('ε _) 0] [((? integer? x) y) (* x y)]))

(: vector-ref2 (All (A) ((Vectorof (Vectorof A)) Integer Integer -> A)))
(define (vector-ref2 v2 r c) (vector-ref (vector-ref v2 r) c))

(: vector-set!2 (All (A) ((Vectorof (Vectorof A)) Integer Integer A -> Void)))
(define (vector-set!2 v2 r c v) (vector-set! (vector-ref v2 r) c v))

(define (northwest-corner-rule! [supply : VI] [demand : VI] [costs : V2R] [M : V2-Shipment/?]) : Void
  (define supply-l (vector-length supply))
  (define demand-l (vector-length demand))
  (let loop ((r 0) (nw 0) (c 0))
    (cond [(= r supply-l) (void)]
          [(= c demand-l) (loop (add1 r) nw 0)]
          [else
           (define quantity (min (vector-ref supply r) (vector-ref demand c)))
           (cond
             [(positive? quantity)
              (define shpmnt (Shipment quantity (vector-ref2 costs r c) r c))
              (vector-set!2 M r c shpmnt)
              (define supply-- (- (vector-ref supply r) quantity))
              (define demand-- (- (vector-ref demand c) quantity))
              (vector-set! supply r supply--)
              (vector-set! demand c demand--)
              (if (zero? supply--) (loop (add1 r) c 0) (loop r nw (add1 c)))]
             [else (loop r nw (add1 c))])])))

(define (stepping-stone! [supply : VI] [demand : VI] [costs : V2R] [M : V2-Shipment/?]) : Void
  (fix-degenerate-case! supply demand costs M)
  (define-values (move leaving max-reduction)
    (for*/fold : (Values Shipments Shipment/? Real)
      ((move : Shipments null) (leaving : Shipment/? #f) (max-reduction : Real 0))
      ((r (vector-length supply))
       (c (vector-length demand))
       (m (in-value (vector-ref2 M r c)))
       #:unless m)
      (define path (let ((trial (Shipment 0 (vector-ref2 costs r c) r c))) (get-closed-path trial M)))
      (define-values (+? reduction leaving-cand lowest-quantity)
        (for/fold : (Values Boolean Real Shipment/? (Option Q))
          ((+? #t) (reduction : Real 0) (leaving-cand : Shipment/? #f) (lowest-q : (Option Q) #f))
          ((s (in-list path)))
          (define s.cpu (Shipment-cost/unit s))
          (if +?
              (values #f (+ reduction s.cpu) leaving-cand lowest-q)
              (let ((reduction-- (- reduction s.cpu))
                    (s.q (Shipment-qty s)))
                (if (or (not lowest-q) (Q<? s.q lowest-q))
                    (values #t reduction-- s s.q)
                    (values #t reduction-- leaving-cand lowest-q))))))

      (if (< reduction max-reduction)
          (values path leaving-cand reduction)
          (values move leaving max-reduction))))

  (unless (null? move)
    (define l.q (Shipment-qty (cast leaving Shipment)))
    (for/fold ((+? : Boolean #t)) ((s (in-list move)))
      (define s.q+ ((if +? Q+ Q-) (Shipment-qty s) l.q))
      (define s+ (struct-copy Shipment s [qty s.q+]))
      (vector-set!2 M (Shipment-r s+) (Shipment-c s+) (if (Q-zero? s.q+) #f s+))
      (not +?))
    (stepping-stone! supply demand costs M)))

(: matrix->list (All (T) ((V2 T) -> (Listof T))))
(define (matrix->list m)
  (for*/list : (Listof T) ((r (in-vector m)) (c (in-vector r)) #:when c)
    c))

(define (fix-degenerate-case! [supply : VI] [demand : VI] [costs : V2R] [M : V2-Shipment/?]) : Void
  (define m-list (matrix->list M))
  (unless (= (+ (vector-length supply) (vector-length demand) -1) (length m-list))
    (let/ec ret : Void
      (for* ((r (vector-length supply)) (c (vector-length demand)) #:unless (vector-ref2 M r c))
        (define dummy (Shipment ε (vector-ref2 costs r c) r c))
        (when (null? (get-closed-path dummy M))
          (vector-set!2 M r c dummy)
          (ret (void)))))))

(: get-closed-path (Shipment V2-Shipment/? -> Shipments))
(define (get-closed-path s matrix)
  ; remove (and keep removing) elements that do not have a vertical AND horizontal neighbour
  (define path
    (let loop : Shipment/?s
      ((path (cons s (matrix->list matrix))))
      (define (has-neighbours [e : Shipment/?]) : Boolean
        (match-define (list n0 n1) (get-neighbours e path))
        (and n0 n1 #t))
      (define-values (with-nbrs w/o-nbrs)
        ((inst partition Shipment/? Shipment/?) has-neighbours path))
      (if (null? w/o-nbrs) with-nbrs (loop with-nbrs))))

  ;; place the remaining elements in the correct plus-minus order
  (define p-len (length path))
  (define-values (senots prev)
    (for/fold : (Values Shipments Shipment/?)
      ((senots : Shipments null) (prev : Shipment/? s))
      ((i p-len))
      (values (if prev (cons prev senots) senots)
              (list-ref (get-neighbours prev path) (modulo i 2)))))
  (reverse senots))

(define (get-neighbours [s : Shipment/?] [lst : Shipment/?s]) : (List Shipment/? Shipment/?)
  (define-values (n0 n1)
    (for/fold : (Values Shipment/? Shipment/?)
      ((n0 : Shipment/? #f) (n1 : Shipment/? #f))
      ((o (in-list lst)) #:when (and o s) #:unless (equal? o s))
      (values (or n0 (and (= (Shipment-r s) (Shipment-r o)) o))
              (or n1 (and (= (Shipment-c s) (Shipment-c o)) o)))))
  (list n0 n1))

(define (print-result [S : VI] [D : VI] [M : V2-Shipment/?] [fmt : String] . [args : Any *]) : Real
  (apply printf (string-append fmt "~%") args)
  (define total-costs
    (for*/sum : Real
      ((r (vector-length S)) (c (vector-length D)))
      (when (zero? c) (unless (zero? r) (newline)))
      (define s (vector-ref2 M r c))
      (cond
        [(and s (= (Shipment-r s) r) (= (Shipment-c s) c))
         (define q (Shipment-qty s))
         (printf "\t~a" q)
         (Q*R q (Shipment-cost/unit s))]
        [else (printf "\t-") 0])))
  (printf "~%Total costs: ~a~%~%" total-costs)
  total-costs)

;; inits from current-input-port --- make sure you set that before coming in
(define (init) : (Values VI VI V2R V2-Shipment/?)
  (define n-sources (cast (read) Integer))
  (define n-destinations (cast (read) Integer))
  (define srcs. (for/list : (Listof Integer) ((_ n-sources)) (cast (read) Integer)))
  (define dsts. (for/list : (Listof Integer) ((_ n-destinations)) (cast (read) Integer)))

  (define sum-src--sum-dest (- (apply + srcs.) (apply + dsts.)))

  (define-values (supply demand)
    (cond [(positive? sum-src--sum-dest) (values srcs. (append dsts. (list sum-src--sum-dest)))]
          [(negative? sum-src--sum-dest) (values (append srcs. (list (- sum-src--sum-dest))) dsts.)]
          [else (values srcs. dsts.)]))

  (define s-l (length supply))
  (define d-l (length demand))
  (define costs (for/vector : V2R ((_ s-l)) ((inst make-vector Real) d-l 0)))
  (define matrix (for/vector : V2-Shipment/? ((_ s-l)) ((inst make-vector Shipment/?) d-l #f)))
  (for* ((i n-sources) (j n-destinations)) (vector-set!2 costs i j (cast (read) Real)))
  (values (list->vector supply) (list->vector demand) costs matrix))

(: transportation-problem (Input-Port -> Real))
(define (transportation-problem p)
  (parameterize ([current-input-port p])
    (define name (read))
    (define-values (supply demand costs matrix) (init))
    (northwest-corner-rule! supply demand costs matrix)
    (stepping-stone! supply demand costs matrix)
    (print-result supply demand matrix "Optimal solutions for: ~s" name)))

(module+ test
  (require typed/rackunit)
  (define (check-tp [in-str : String] [expected-cost : Real])
    (define cost ((inst call-with-input-string Real) in-str transportation-problem))
    (check-equal? cost expected-cost))

  (check-tp #<<$
input1
 2 3
25 35
20 30 10
3 5 7
3 2 5
$
            180)

  (check-tp #<<$
input2
3 3
12 40 33
20 30 10
3 5 7
2 4 6
9 1 8
$
            130)

  (check-tp #<<$
input3
4 4
14 10 15 12
10 15 12 15
10 30 25 15
20 15 20 10
10 30 20 20
30 40 35 45
$
            1000))
