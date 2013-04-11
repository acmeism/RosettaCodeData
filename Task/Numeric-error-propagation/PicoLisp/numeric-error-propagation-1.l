(scl 12)
(load "@lib/math.l")

# Overload arithmetic operators +, -, *, / and **
(redef + @
   (let R (next)
      (while (args)
         (let N (next)
            (setq R
               (if2 (atom R) (atom N)
                  (+ R N)                       # c + c
                  (cons (+ R (car N)) (cdr N))  # c + a
                  (cons (+ (car R) N) (cdr R))  # a + c
                  (cons                         # a + b
                     (+ (car R) (car N))
                     (+ (cdr R) (cdr N)) ) ) ) ) )
      R ) )

(redef - @
   (let R (next)
      (ifn (args)
         (- R)
         (while (args)
            (let N (next)
               (setq R
                  (if2 (atom R) (atom N)
                     (- R N)                       # c - c
                     (cons (- R (car N)) (cdr N))  # c - a
                     (cons (- (car R) N) (cdr R))  # a - c
                     (cons                         # a - b
                        (- (car R) (car N))
                        (+ (cdr R) (cdr N)) ) ) ) ) )
         R ) ) )

(redef * @
   (let R (next)
      (while (args)
         (let N (next)
            (setq R
               (if2 (atom R) (atom N)
                  (* R N)                                        # c * c
                  (cons                                          # c * a
                     (*/ R (car N) 1.0)
                     (mul2div2 (cdr N) R 1.0) )
                  (cons                                          # a * c
                     (*/ (car R) N 1.0)
                     (mul2div2 (cdr R) N 1.0) )
                  (uncMul (*/ (car R) (car N) 1.0) R N) ) ) ) )  # a * b
      R ) )

(redef / @
   (let R (next)
      (while (args)
         (let N (next)
            (setq R
               (if2 (atom R) (atom N)
                  (/ R N)                                        # c / c
                  (cons                                          # c / a
                     (*/ R 1.0 (car N))
                     (mul2div2 (cdr N) R 1.0) )
                  (cons                                          # a / c
                     (*/ (car R) 1.0 N)
                     (mul2div2 (cdr R) N 1.0) )
                  (uncMul (*/ (car R) 1.0 (car N)) R N) ) ) ) )  # a / b
      R ) )

(redef ** (A C)
   (if (atom A)
      (** A C)
      (let F (pow (car A) C)
         (cons F
            (mul2div2 (cdr A) (*/ F C (car A)) 1.0) ) ) ) )

# Utilities
(de mul2div2 (A B C)
   (*/ A B B (* C C)) )

(de uncMul (F R N)
   (cons F
      (mul2div2
         (+
            (mul2div2 (cdr R) 1.0 (car R))
            (mul2div2 (cdr N) 1.0 (car N)) )
         F
         1.0 ) ) )

# I/O conversion
(de unc (N U)
   (if U
      (cons N (*/ U U 1.0))
      (pack
         (round (car N) 10)
         " ± "
         (round (sqrt (* 1.0 (cdr N))) 8) ) ) )
