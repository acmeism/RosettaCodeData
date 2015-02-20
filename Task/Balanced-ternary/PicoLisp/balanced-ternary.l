(seed (in "/dev/urandom" (rd 8)))

(setq *G '((0 -1) (1 -1) (-1 0) (0 0) (1 0) (-1 1) (0 1)))

# For humans
(de negh (L)
   (mapcar
      '((I)
         (case I
            (- '+)
            (+ '-)
            (T 0) ) )
      L ) )

(de trih (X)
   (if (num? X)
      (let (S (lt0 X)  X (abs X)  R NIL)
         (if (=0 X)
            (push 'R 0)
            (until (=0 X)
               (push 'R
                  (case (% X 3)
                     (0 0)
                     (1 '+)
                     (2 (inc 'X) '-) ) )
               (setq X (/ X 3)) ) )
         (if S (pack (negh R)) (pack R)) )
      (let M 1
         (sum
            '((C)
               (prog1
                  (unless (= C "0") ((intern C) M))
                  (setq M (* 3 M)) ) )
            (flip (chop X)) ) ) ) )

# For robots
(de neg (L)
   (mapcar
      '((I)
         (case I (-1 1) (1 -1) (T 0)) )
      L ) )

(de tri (X)
   (if (num? X)
      (let (S (lt0 X)  X (abs X)  R NIL)
         (if (=0 X)
            (push 'R 0)
            (until (=0 X)
               (push 'R
                  (case (% X 3)
                     (0 0)
                     (1 1)
                     (2 (inc 'X) (- 1)) ) )
               (setq X (/ X 3)) ) )
         (flip (if S (neg R) R)) )
      (let M 1
         (sum
            '((C)
               (prog1 (* C M) (setq M (* 3 M))) )
            X ) ) ) )

(de add (D1 D2)
   (let
      (L (max (length D1) (length D2))
         D1 (need (- L) D1 0)
         D2 (need (- L) D2 0)
         C 0 )
      (mapcon
         '((L1 L2)
            (let R
               (get
                  *G
                  (+ 4 (+ (car L1) (car L2) C)) )
               (ifn (cdr L1)
                  R
                  (setq C (cadr R))
                  (cons (car R)) ) ) )
         D1
         D2 ) ) )

(de mul (D1 D2)
   (ifn (and D1 D2)
      0
      (add
         (case (car D1)
            (0 0)
            (1 D2)
            (-1 (neg D2)) )
         (cons 0 (mul (cdr D1) D2) ) ) ) )

(de sub (D1 D2)
   (add D1 (neg D2)) )

# Random testing
(let (X 0  Y 0  C 2048)
   (do C
      (setq
         X (rand (- C) C)
         Y (rand (- C) C) )
      (test X (trih (trih X)))
      (test X (tri (tri X)))
      (test
         (+ X Y)
         (tri (add (tri X) (tri Y))) )
      (test
         (- X Y)
         (tri (sub (tri X) (tri Y))) )
      (test
         (* X Y)
         (tri (mul (tri X) (tri Y))) ) ) )

(println 'A (trih 523) (trih "+-0++0+"))
(println 'B (trih -436) (trih "-++-0--"))
(println 'C (trih 65) (trih "+-++-"))
(let R
   (tri
      (mul
         (tri (trih "+-0++0+"))
         (sub (tri -436) (tri (trih "+-++-"))) ) )
   (println 'R (trih R) R) )

(bye)
