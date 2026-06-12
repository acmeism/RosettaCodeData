#lang racket
(require racket/fixnum)

(define current-dim (make-parameter 10))
(define current-dim-- (make-parameter 9))
(define current-dim² (make-parameter 100))
(define current-kT (make-parameter 1))
(define current-k-max (make-parameter 1000000))
(define current-monitor-frequency (make-parameter 100000))
(define current-monitor (make-parameter
                          (λ (s k T E)
                             (when (zero? (modulo k (current-monitor-frequency)))
                               (printf "T:~a E:~a~%" (~r T) E)))))

;; Simulated Annealing Solver
(define (P ΔE T)
  (if (negative? ΔE) 1 (exp (- (/ ΔE T)))))

(define (solve/SA s₀ next-s k-max temperature E monitor)
  (for*/fold ((s s₀) (E_s (E s₀)))
             ((k (in-range k-max)))
    (define T (temperature k k-max))
    (when monitor (monitor s k T E_s))
    (let* ((s´ (next-s s k))
           (E_s´ (E s´))
           (ΔE (- E_s´ E_s)))
      (if (>= (P ΔE T) (random)) (values s´ E_s´) (values s E_s)))))

(define (temperature k k-max)
  (* (current-kT) (- 1 (/ k k-max))))

;; TSP Problem
(struct tsp (path indices Es ΣE) #:transparent)

(define (y/x i d) (quotient/remainder i d))

(define (dist a b (d (current-dim)))
  (let-values (([ay ax] (y/x a d)) ([by bx] (y/x b d)))
    (sqrt (+ (sqr (- ay by)) (sqr (- ax bx))))))

(define (indices->tsp indices)
  (define path (make-fxvector (current-dim²)))
  (for ((i indices) (n (current-dim²))) (fxvector-set! path i n))
  (define Es (for/vector #:length (fxvector-length path)
               ((a (in-fxvector path))
                (b (in-sequences (in-fxvector path 1) (in-value (fxvector-ref path 0)))))
               (dist a b)))
  (tsp path indices Es (for/sum ((E Es)) E)))

(define (dir->delta dir (dim (current-dim))) (case dir [(l) -1] [(r) +1] [(u) (- dim)] [(d) dim]))

(define (invalid-direction? x y d (mx (current-dim--)))
  (match* (x y d) ((0 _ 'l) #t) (((== mx) _ 'r) #t)  ((_ 0 'u) #t) ((_ (== mx) 'd) #t) ((_ _ _) #f)))

;; extended to take k to reset numerical drift from the Δ calculation
(define (tsp:swap-one-neighbour t k)
  (define dim (current-dim))
  (define dim² (current-dim²))
  (define candidate (random dim²))
  (define-values [cy cx] (quotient/remainder candidate dim))
  (define dir (vector-ref #(l r u d) (random 4)))
  (cond
    [(invalid-direction? cx cy dir) (tsp:swap-one-neighbour t k)]
    [else
     (define delta (dir->delta dir))
     (define neighbour (+ candidate delta))
     (define path´ (fxvector-copy (tsp-path t)))
     (define indices´ (fxvector-copy (tsp-indices t)))
     (define cand-idx (fxvector-ref (tsp-indices t) candidate))
     (define ngbr-idx (fxvector-ref (tsp-indices t) neighbour))
     (fxvector-set! path´ cand-idx neighbour)
     (fxvector-set! path´ ngbr-idx candidate)
     (fxvector-set! indices´ candidate ngbr-idx)
     (fxvector-set! indices´ neighbour cand-idx)
     (define Es (tsp-Es t))
     (define Es´ (vector-copy Es))

     (let* ((cand-idx++ (modulo (add1 cand-idx) dim²))
            (cand-idx-- (modulo (sub1 cand-idx) dim²))
            (ngbr-idx++ (modulo (add1 ngbr-idx) dim²))
            (ngbr-idx-- (modulo (sub1 ngbr-idx) dim²)))
     (define Σold-E-around-nodes
       (+ (vector-ref Es cand-idx) (vector-ref Es cand-idx--)
          (vector-ref Es ngbr-idx) (vector-ref Es ngbr-idx--)))
     (define E´-at-cand (dist (fxvector-ref path´ cand-idx) (fxvector-ref path´ cand-idx++)))
     (define E´-pre-cand (dist (fxvector-ref path´ cand-idx) (fxvector-ref path´ cand-idx--)))
     (define E´-at-ngbr (dist (fxvector-ref path´ ngbr-idx) (fxvector-ref path´ ngbr-idx++)))
     (define E´-pre-ngbr (dist (fxvector-ref path´ ngbr-idx) (fxvector-ref path´ ngbr-idx--)))
     (vector-set! Es´ cand-idx E´-at-cand)
     (vector-set! Es´ cand-idx-- E´-pre-cand)
     (vector-set! Es´ ngbr-idx E´-at-ngbr)
     (vector-set! Es´ ngbr-idx-- E´-pre-ngbr)

     (define ΔE (- (+ E´-at-cand E´-pre-cand E´-at-ngbr E´-pre-ngbr) Σold-E-around-nodes))
     (tsp path´ indices´ Es´
          (if (zero? (modulo k 1000)) (for/sum ((e Es´)) e) (+ (tsp-ΣE t) ΔE))))]))

(define (tsp:random-state)
  (indices->tsp (for/fxvector ((i (shuffle (range (current-dim²))))) i)))

(define (Simulated-annealing)
  (define-values (solution solution-E)
    (solve/SA (tsp:random-state)
              tsp:swap-one-neighbour
              (current-k-max)
              temperature
              tsp-ΣE
              (current-monitor)))
  (displayln (tsp-path solution))
  (displayln solution-E))

(module+ main
         (Simulated-annealing))
