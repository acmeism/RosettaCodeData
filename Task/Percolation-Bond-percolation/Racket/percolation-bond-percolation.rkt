#lang racket

(define has-left-wall?   (lambda (x) (bitwise-bit-set? x 0)))
(define has-right-wall?  (lambda (x) (bitwise-bit-set? x 1)))
(define has-top-wall?    (lambda (x) (bitwise-bit-set? x 2)))
(define has-bottom-wall? (lambda (x) (bitwise-bit-set? x 3)))
(define has-fluid?       (lambda (x) (bitwise-bit-set? x 4)))

(define (walls->cell l? r? t? b?)
  (+ (if l? 1 0) (if r? 2 0) (if t? 4 0) (if b? 8 0)))

(define (bonded-percol-grid M N p)
  (define rv (make-vector (* M N)))
  (for* ((idx (in-range (* M N))))
    (define left-wall?
      (or (zero? (modulo idx M))
          (has-right-wall? (vector-ref rv (sub1 idx)))))
    (define right-wall?
      (or (= (modulo idx M) (sub1 M))
          (< (random) p)))
    (define top-wall?
      (if (< idx M) (< (random) p)
          (has-bottom-wall? (vector-ref rv (- idx M)))))
    (define bottom-wall? (< (random) p))
    (define cell-value
      (walls->cell left-wall? right-wall? top-wall? bottom-wall?))
    (vector-set! rv idx cell-value))
  rv)

(define (display-percol-grid M . vs)
  (define N (/ (vector-length (car vs)) M))
  (define-syntax-rule (tab-eol m)
    (when (= m (sub1 M)) (printf "\t")))
  (for ((n N))
    (for* ((v vs) (m M))
      (when (zero? m) (printf "+"))
      (printf
       (match (vector-ref v (+ (* n M) m))
         ((? has-top-wall?) "-+")
         ((? has-fluid?)    "#+")
         (else ".+")))
      (tab-eol m))
    (newline)
    (for* ((v vs) (m M))
      (when (zero? m) (printf "|"))
      (printf
       (match (vector-ref v (+ (* n M) m))
         ((and (? has-fluid?) (? has-right-wall?)) "#|")
         ((? has-right-wall?) ".|")
         ((? has-fluid?) "##")
         (else "..")))
      (tab-eol m))
    (newline))
  (for* ((v vs) (m M))
    (when (zero? m) (printf "+"))
    (printf
     (match (vector-ref v (+ (* (sub1 M) M) m))
       ((? has-bottom-wall?) "-+")
       ((? has-fluid?)    "#+")
       (else ".+")))
    (tab-eol m))
  (newline))

(define (find-bonded-grid-t/b-path M v)
  (define N (/ (vector-length v) M))

  (define (flood-cell idx)
    (cond
      [(= (quotient idx M) N) #t] ; wootiments!
      [(has-fluid? (vector-ref v idx)) #f] ; been here
      [else (define cell (vector-ref v idx))
            (vector-set! v idx (bitwise-ior cell 16))
            (or (and (not (has-bottom-wall? cell)) (flood-cell (+ idx M)))
                (and (not (has-left-wall? cell))   (flood-cell (- idx 1)))
                (and (not (has-right-wall? cell))  (flood-cell (+ idx 1)))
                (and (not (has-top-wall? cell))
                     (>= idx M) ; not top row
                     (flood-cell (- idx M))))]))

  (for/first ((m (in-range M))
              #:unless (has-top-wall? (vector-ref v m))
              #:when (flood-cell m)) #t))

(define t (make-parameter 1000))
(define (experiment p)
  (/ (for*/sum ((sample (in-range (t)))
                (v (in-value (bonded-percol-grid 10 10 p)))
                #:when (find-bonded-grid-t/b-path 10 v)) 1)
     (t)))

(define (main)
  (for ((tenths (in-range 0 (add1 10))))
    (define p (/ tenths 10))
    (define e (experiment p))
    (printf "proportion of grids that percolate p=~a : ~a (~a)~%"
            p e (real->decimal-string e 5))))

(module+ test
  (define (make/display/flood/display-bonded-grid M N p attempts (atmpt 1))
    (define v (bonded-percol-grid M N p))
    (define v+ (vector-copy v))
    (cond [(or (find-bonded-grid-t/b-path M v+) (= attempts 0))
           (define v* (vector-copy v+))
           (define (flood-bonded-grid)
             (when (find-bonded-grid-t/b-path M v*)
               (flood-bonded-grid)))
           (flood-bonded-grid)
           (display-percol-grid M v v+ v*)
           (printf "After ~a attempt(s)~%~%" atmpt)]
          [else
           (make/display/flood/display-bonded-grid
            M N p (sub1 attempts) (add1 atmpt))]))

  (make/display/flood/display-bonded-grid 10 10 0   20)
  (make/display/flood/display-bonded-grid 10 10 .25 20)
  (make/display/flood/display-bonded-grid 10 10 .50 20)
  (make/display/flood/display-bonded-grid 10 10 .75 20000))
