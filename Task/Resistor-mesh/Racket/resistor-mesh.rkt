#lang racket
(require racket/flonum)

(define-syntax-rule (fi c t f) (if c f t))

(define (neighbours w h)
  (define h-1 (sub1 h))
  (define w-1 (sub1 w))
  (lambda (i j)
    (+ (fi (zero? i) 1 0)
       (fi (zero? j) 1 0)
       (if (< i h-1) 1 0)
       (if (< j w-1) 1 0))))

(define (mesh-R probes w h)
  (define h-1 (sub1 h))
  (define w-1 (sub1 w))

  (define-syntax-rule (v2ref v r c) ; 2D vector ref
    (flvector-ref v (+ (* r w) c)))

  (define w*h (* w h))

  (define (alloc2 (v 0.))
    (make-flvector w*h v))

  (define nghbrs (neighbours w h))

  (match-define `((,fix+r ,fix+c) (,fix-r ,fix-c)) probes)
  (define fix+idx (+ fix+c (* fix+r w)))
  (define fix-idx (+ fix-c (* fix-r w)))
  (define fix-val
    (match-lambda**
     [((== fix+idx) _) 1.]
     [((== fix-idx) _) -1.]
     [(_ v) v]))

  (define (calc-diff m)
    (define d
      (for*/flvector #:length w*h ((i (in-range h)) (j (in-range w)))
        (define v
          (+ (fi (zero? i) (v2ref m (- i 1) j) 0)
             (fi (zero? j) (v2ref m i (- j 1)) 0)
             (if (< i h-1) (v2ref m (+ i 1) j) 0)
             (if (< j w-1) (v2ref m i (+ j 1)) 0)))
        (- (v2ref m i j) (/ v (nghbrs i j)))))

    (define Δ
      (for/sum ((i (in-naturals)) (d.v (in-flvector d)) #:when (= (fix-val i 0.) 0.))
        (sqr d.v)))

    (values d Δ))

  (define final-d
    (let loop ((m (alloc2)) (d (alloc2)))
      (define m+ ; do this first will get the boundaries on
        (for/flvector #:length w*h ((j (in-naturals)) (m.v (in-flvector m)) (d.v (in-flvector d)))
          (fix-val j (- m.v d.v))))

      (define-values (d- Δ) (calc-diff m+))

      (if (< Δ 1e-24) d (loop m+ d-))))

  (/ 2
     (/ (- (* (v2ref final-d fix+r fix+c) (nghbrs fix+r fix+c))
           (* (v2ref final-d fix-r fix-c) (nghbrs fix-r fix-c)))
        2)))

(module+ main
  (printf "R = ~a~%" (mesh-R '((1 1) (6 7)) 10 10)))
