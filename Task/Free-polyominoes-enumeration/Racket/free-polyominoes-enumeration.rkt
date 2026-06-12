#lang typed/racket
;; Inspired by C code in http://www.geocities.jp/tok12345/countomino.txt
;; but tries to take advantage of arbitrary width integers
(define-type Order Positive-Integer)
(define-type Shape Nonnegative-Integer)
;; "shape" functions are abbreviated s-...
(define-type Shapes (Listof Shape))
(define-type Shapes+ (Pairof Shape Shapes))
;; polynomino
;;  order: number of bits wide a row of the "shape" is
;;  shape: bit map (integer). bits set where the "animal" is
(struct polynominoes ([order : Order] [shapes : Shapes]))
(define-type shape-xform (Order Shape -> Shape))
(: s-reflect:y shape-xform)
(: s-reflect:x shape-xform)
(: s-reflect:xy shape-xform)
(: s-reflect:x=y shape-xform)
(: s-all-xforms (Order Shape #:bottom-mask Shape #:left-mask Shape -> Shapes))
(: s-grow+2 shape-xform)
(: s-shrink-1 shape-xform)
(: s-normalise (Order Shape #:bottom-mask Shape #:left-mask Shape -> Shape))
(: draw-shapes (Order Shapes -> Void))
(: draw-polynominoes (polynominoes -> Void))
(: polynominoes->string (polynominoes -> String))
(: order-1-polynominoes polynominoes)
(: shape-add-bit (Order Shape Nonnegative-Integer -> Shape))
(: s-add-all-edges
   (Order (Shape -> Shape) Shape #:bottom-mask Shape #:left-mask Shape (#:seen? (Shape -> Boolean))
          (#:seen! (Option (Shape -> Void))) -> Shapes))
(: s-least-xform (Order Shape #:bottom-mask Shape #:left-mask Shape
                        (#:seen? (Option (Shape -> Boolean))) -> (Option Shape)))
(: polynominoes-add-new-order (-> polynominoes polynominoes))
(: nth-order-polynominoes (-> Positive-Integer polynominoes))
(: s-identity shape-xform)
(: order->bottom-mask (Order -> Shape))
(: order->left-mask (Order -> Shape))

;; get in touch with your inner C programmer
(define << arithmetic-shift)
(define bits bitwise-bit-field)

(define (draw-shapes o sss)
  (let: loop ((need-newline? : Boolean #f) (sss sss))
    (define 10-or-sss-len (min (length sss) 10))
    (define ss (take sss 10-or-sss-len))
    (for ((y (in-range 0 o)))
      (for ((s (in-list ss)) (n (in-naturals)) #:when #t (x (in-range 0 o)))
        (match* (n y x)
          [(0 0 _) (void)] [(0 _ 0) (newline)] [(_ _ 0) (write-char #\space)] [(_ _ _) (void)])
        (write-char (cond [(bitwise-bit-set? s (+ x (* y o))) #\#] [else #\.]))))
    (newline)
    (define sss- (drop sss 10-or-sss-len))
    (unless (null? sss-) (when need-newline? (newline)) (loop #t sss-))))

(define (draw-polynominoes p)
  (draw-shapes (polynominoes-order p) (polynominoes-shapes p)))

(define (polynominoes->string p)
  (with-output-to-string (λ () (draw-polynominoes p))))

(define order-1-polynominoes (polynominoes 1 '(1)))

(define (shape-add-bit o s b)
  (bitwise-ior s (<< 1 b)))

(define (s-reflect:y o s)
  (let: loop ((s : Shape s) (s+ : Shape 0))
    (if (zero? s) s+ (loop (<< s (- o)) (bitwise-ior (bits s 0 o) (<< s+ o))))))

(define (s-reflect:x o s)
  (let y-loop ((s+ : Shape 0) (y : Nonnegative-Integer (- o 1)))
    (let x-loop ((s+ : Shape s+) (x : Nonnegative-Integer 0) (b (* o y)))
      (cond [(= o x) (if (= y 0) s+ (y-loop s+ (- y 1)))]
            [else (x-loop (bitwise-ior (<< s+ 1) (bits s b (+ b 1))) (+ x 1) (+ b 1))]))))

(define (s-reflect:xy o s) (s-reflect:x o (s-reflect:y o s)))

(define (s-reflect:x=y o s)
  (define o-1 (sub1 o))
  (let b-loop ((s+ : Shape 0) (w-y o-1) (w-x o-1))
    (cond [(< w-y 0) s+]
          [else (define r-bit (+ (* w-x o) w-y))
                (b-loop (bitwise-ior (<< s+ 1) (bits s r-bit (+ r-bit 1)))
                        (if (zero? w-x) (sub1 w-y) w-y)
                        (if (zero? w-x) o-1 (sub1 w-x)))])))

(define (s-identity o s) s)

(define (order->bottom-mask o) (- (expt 2 o) 1))

(define (order->left-mask o) (for/fold ((m : Shape 0)) ((i (in-range 0 o))) (bitwise-ior 1 (<< m o))))

(define (s-least-xform o s #:bottom-mask bm #:left-mask lm #:seen? (seen? #f))
  (: ss1 (Option Shapes))
  (define ss1
    (let loop : (Option Shapes)
      ((rv : (Option Shapes) null)
       (xs : (Listof shape-xform)
           (list s-identity s-reflect:y s-reflect:x s-reflect:xy)))
      (cond
        [(null? xs) rv]
        [(not rv) #f] ; option assures rv's type in else clause
        [else
         (define s_ (s-normalise o ((car xs) o s) #:bottom-mask bm #:left-mask lm))
         (if (and seen? (seen? s_)) #f (loop (cons s_ rv) (cdr xs)))])))

  (and ss1
       (let loop : (Option Shape)
         ((rv : (Option Shape) (sub1 (expt 2 (sqr o))))
          (ss : Shapes ss1))
         (cond
           [(null? ss) rv]
           [else
            (define s0 (car ss))
            (define s_ (s-normalise o (s-reflect:x=y o s0) #:bottom-mask bm #:left-mask lm))
            (define least-s (min s0 s_))
            (cond [(and seen? (seen? s_)) #f]
                  [else (and rv (loop (min rv least-s) (cdr ss)))])]))))

(define (s-all-xforms o s #:bottom-mask bm #:left-mask lm)
  (: s1 Shapes)
  (: s2 Shapes)
  (define s1
    (for/list : Shapes
      ((x : shape-xform (in-list (list s-reflect:y s-reflect:x s-reflect:xy))))
      (x o s)))
  (define s2
    (for/list : Shapes ((s+ : Shape (in-list (cons s s1))))
      (s-reflect:x=y o s+)))

  (for/list : Shapes ((s (in-list (append s1 s2))))
    (s-normalise o s #:bottom-mask bm #:left-mask lm)))

(define (s-grow+2 o s)
  (define o+2 (+ o 2))
  (define -o (- o))
  (define s+
    (let: loop : Shape ((s : Shape s) (shft : Nonnegative-Integer 0) (rv : Shape 0))
      (if (zero? s) rv
          (loop (<< s -o)
                (+ shft o+2)
                (bitwise-ior rv (<< (bits s 0 o) shft))))))
  (<< s+ (+ o+2 1))) ; centre it

(define (s-shrink-1 o s)
  (define o-1 (sub1 o))
  (define -o (- o))
  (let: loop : Shape ((s- : Shape s) (shft : Nonnegative-Integer 0) (rv : Shape 0))
    (if (zero? s-) rv (loop (<< s- -o) (+ shft o-1) (bitwise-ior rv (<< (bits s- 0 o) shft))))))

(define (s-normalise o s #:bottom-mask bm #:left-mask lm)
  (cond [(zero? s) s]; stop an infinte loop!
        [else
         (define -o (- o))
         ;; if there are no bits in a mask, we need to pull some in from...
         (: s-down Shape)
         (define s-down (let: loop : Shape ((s : Shape s))
                          (if (zero? (bitwise-and s bm)) (loop (<< s -o)) s)))
         (let loop : Shape ((s : Shape s-down)) (if (zero? (bitwise-and s lm)) (loop (<< s -1)) s))]))

(define (s-add-all-edges o shrink s
                         #:bottom-mask bm #:left-mask lm
                         #:seen! (seen! #f) #:seen? (seen? #f))
  (define o+2 (+ o 2))
  (define s+ (s-grow+2 o s))
  ;; it will be of a new order with edges all round -- so expand it into that
  (define blur (bitwise-ior s+ (<< s+ 1) (<< s+ -1) (<< s+ o+2) (<< s+ (- o+2))))
  (let: loop : Shapes
    ((b : Nonnegative-Integer 0)
     (e : Shape (bitwise-xor blur s+)) ; the edge is the blur, less the original s+
     (rv : Shapes null))
    (match e
      [0 rv] ; run out of bits
      [(? even?) (loop (+ b 1) (<< e -1) rv)] ; bit 0 isn't
      [_ (define lsx (s-least-xform o+2 (shape-add-bit o+2 s+ b)
                                    #:bottom-mask bm #:left-mask lm #:seen? seen?))
         (loop (+ b 1) (<< e -1) (if lsx (begin0 (cons (shrink lsx) rv)
                                                 (when seen! (seen! lsx)))
                                     rv))])))

(define (polynominoes-add-new-order p)
  (match-define (polynominoes o ss) p)
  (: saae (Shape -> Shapes))
  (: seen? (Shape -> Boolean))
  (: seen! (Shape -> Void))

  (define bm (order->bottom-mask (+ 2 o)))
  (define lm (order->left-mask (+ 2 o)))
  (define shrink (curry s-shrink-1 (+ o 2)))
  (define (seen! s) (hash-set! all-seen-shapes s #t))
  (define (seen? s) (hash-ref all-seen-shapes s #f))
  (define (saae s) (s-add-all-edges o shrink s #:seen? seen? #:seen! seen!
                                    #:bottom-mask bm #:left-mask lm))
  (define all-seen-shapes #{(make-hash) :: (HashTable Shape Boolean)})
  (define all-new-shapes
    (for*/list : Shapes ((k : Shape (in-list ss)) (s : Shape (in-list (saae k)))) s))
  (polynominoes (add1 o) all-new-shapes))

(define nth-order-polynominoes
  (let ((polynominoes-cache #{(make-hash) :: (HashTable Positive-Integer polynominoes)}))
    (hash-set! polynominoes-cache 1 order-1-polynominoes)
    (lambda (n)
      (hash-ref! polynominoes-cache n
                 (λ () (polynominoes-add-new-order
                        (nth-order-polynominoes (cast (sub1 n) Positive-Integer))))))))

(module+ main
  (time
   (for ((n : Positive-Integer (in-range 1 (add1 12))))
     (define p (time (nth-order-polynominoes n)))
     (printf "n: ~a~%" n)
     (when (< n 6) (draw-polynominoes p))
     (printf "count: ~a~%~%" (length (polynominoes-shapes p)))
     (flush-output))))
