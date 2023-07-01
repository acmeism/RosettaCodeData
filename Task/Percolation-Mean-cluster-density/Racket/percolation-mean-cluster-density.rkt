#lang racket
(require srfi/14) ; character sets

; much faster than safe fixnum functions
(require
  racket/require ; for fancy require clause below
  (filtered-in
          (lambda (name) (regexp-replace #rx"unsafe-" name ""))
          racket/unsafe/ops)
  ; these aren't in racket/unsafe/ops
  (only-in racket/fixnum for/fxvector in-fxvector fxvector-copy))

; ...(but less safe). if in doubt use this rather than the one above
; (require racket/fixnum)

(define t (make-parameter 5))

(define (build-random-grid p M N)
  (define p-num (numerator p))
  (define p-den (denominator p))
  (for/fxvector #:length (fx* M N) ((_ (in-range (* M N))))
                (if (< (random p-den) p-num) 1 0)))

(define letters
  (sort (char-set->list (char-set-intersection
                         char-set:letter
                         ; char-set:ascii
                         )) char<?))
(define n-letters (length letters))
(define cell->char
  (match-lambda
    (0 #\space) (1 #\.)
    (c (list-ref letters (modulo (- c 2) n-letters)))))

(define (draw-percol-grid M N . gs)
  (for ((r N))
    (for ((g gs))
      (define row-str
        (list->string
         (for/list ((idx (in-range (* r M) (* (+ r 1) M))))
           (cell->char (fxvector-ref g idx)))))
      (printf "|~a| " row-str))
    (newline)))

(define (count-clusters! M N g)
  (define (gather-cluster! k c)
    (when (fx= 1 (fxvector-ref g k))
      (define k-r (fxquotient k M))
      (define k-c (fxremainder k M))
      (fxvector-set! g k c)
      (define-syntax-rule (gather-surrounds range? k+)
        (let ((idx k+))
          (when (and range? (fx= 1 (fxvector-ref g idx)))
            (gather-cluster! idx c))))
      (gather-surrounds (fx> k-r 0) (fx- k M))
      (gather-surrounds (fx> k-c 0) (fx- k 1))
      (gather-surrounds (fx< k-c (fx- M 1)) (fx+ k 1))
      (gather-surrounds (fx< k-r (fx- N 1)) (fx+ k M))))

  (define-values (rv _c)
    (for/fold ((rv 0) (c 2))
      ((pos (in-range (fx* M N)))
       #:when (fx= 1 (fxvector-ref g pos)))
      (gather-cluster! pos c)
      (values (fx+ rv 1) (fx+ c 1))))
  rv)

(define (display-sample-clustering p)
  (printf "Percolation cluster sample: p=~a~%" p)
  (define g (build-random-grid p 15 15))
  (define g+ (fxvector-copy g))
  (define g-count (count-clusters! 15 15 g+))
  (draw-percol-grid 15 15 g g+)
  (printf "~a clusters~%" g-count))

(define (experiment p n t)
  (printf "Experiment: ~a ~a ~a\t" p n t) (flush-output)
  (define sum-Cn
    (for/sum ((run (in-range t)))
      (printf "[~a" run) (flush-output)
      (define g (build-random-grid p n n))
      (printf "*") (flush-output)
      (define Cn (count-clusters! n n g))
      (printf "]") (flush-output)
      Cn))
  (printf "\tmean K(p) = ~a~%" (real->decimal-string (/ sum-Cn t (sqr n)) 6)))

(module+ main
  (t 10)
  (for ((n (in-list '(4000 1000 750 500 400 300 200 100 15))))
    (experiment 1/2 n (t)))
  (display-sample-clustering 1/2))

(module+ test
  (define grd (build-random-grid 1/2 1000 1000))
  (/ (for/sum ((g (in-fxvector grd)) #:when (zero? g)) 1) (fxvector-length grd))
  (display-sample-clustering 1/2))
