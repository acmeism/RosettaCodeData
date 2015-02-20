#lang racket
(require racket/require (only-in racket/fixnum for*/fxvector))
(require (filtered-in (lambda (name) (regexp-replace #rx"unsafe-" name ""))
                      racket/unsafe/ops))

(define cell-empty   0)
(define cell-filled  1)
(define cell-wall    2)
(define cell-visited 3)
(define cell-exit    4)

(define ((percol->generator p)) (if (< (random) p) cell-filled cell-empty))

(define t (make-parameter 1000))

(define ((make-percol-grid M N) p)
  (define p->10 (percol->generator p))
  (define M+1 (fx+ 1 M))
  (define M+2 (fx+ 2 M))
  (for*/fxvector
   #:length (fx* N M+2)
   ((n (in-range N)) (m (in-range M+2)))
   (cond
     [(fx= 0 m) cell-wall]
     [(fx= m M+1) cell-wall]
     [else (p->10)])))

(define (cell->str c) (substring " #|+*" c (fx+ 1 c)))

(define ((draw-percol-grid M N) g)
  (define M+2 (fx+ M 2))
  (for ((row N))
    (for ((col (in-range M+2)))
      (define idx (fx+ (fx* M+2 row) col))
      (printf "~a" (cell->str (fxvector-ref g idx))))
    (newline)))

(define ((percolate-percol-grid?! M N) g)
  (define M+2 (fx+ M 2))
  (define N-1 (fx- N 1))
  (define max-idx (fx* N M+2))
  (define (inner-percolate g idx)
    (define row (fxquotient idx M+2))
    (cond
      ((fx< idx 0) #f)
      ((fx>= idx max-idx) #f)
      ((fx= N-1 row) (fxvector-set! g idx cell-exit) #t)
      ((fx= cell-filled (fxvector-ref g idx))
       (fxvector-set! g idx cell-visited)
       (or
        ; gravity first (thanks Mr Newton)
        (inner-percolate g (fx+ idx M+2))
        ; stick-to-the-left
        (inner-percolate g (fx- idx 1))
        (inner-percolate g (fx+ idx 1))
        ; go uphill only if we have to!
        (inner-percolate g (fx- idx M+2))))
      (else #f)))
  (for/first ((m (in-range 1 M+2)) #:when (inner-percolate g m)) g))

(define make-15x15-grid (make-percol-grid 15 15))
(define draw-15x15-grid (draw-percol-grid 15 15))
(define perc-15x15-grid?! (percolate-percol-grid?! 15 15))

(define (display-sample-percolation p)
  (printf "Percolation sample: p=~a~%" p)
  (for*/first
      ((i (in-naturals))
       (g (in-value (make-15x15-grid 0.6)))
       #:when (perc-15x15-grid?! g))
    (draw-15x15-grid g))
  (newline))

(display-sample-percolation 0.4)

(for ((p (sequence-map (curry * 1/10) (in-range 0 (add1 10)))))
  (define n-percolated-grids
    (for/sum
     ((i (in-range (t))) #:when (perc-15x15-grid?! (make-15x15-grid p))) 1))
  (define proportion-percolated (/ n-percolated-grids (t)))
  (printf "p=~a\t->\t~a~%" p (real->decimal-string proportion-percolated 4)))
