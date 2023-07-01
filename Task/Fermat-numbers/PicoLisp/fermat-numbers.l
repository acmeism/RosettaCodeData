(seed (in "/dev/urandom" (rd 8)))
(de **Mod (X Y N)
   (let M 1
      (loop
         (when (bit? 1 Y)
            (setq M (% (* M X) N)) )
         (T (=0 (setq Y (>> 1 Y)))
            M )
         (setq X (% (* X X) N)) ) ) )
(de isprime (N)
   (cache '(NIL) N
      (if (== N 2)
         T
         (and
            (> N 1)
            (bit? 1 N)
            (let (Q (dec N)  N1 (dec N)  K 0  X)
               (until (bit? 1 Q)
                  (setq
                     Q (>> 1 Q)
                     K (inc K) ) )
               (catch 'composite
                  (do 16
                     (loop
                        (setq X
                           (**Mod
                              (rand 2 (min (dec N) 1000000000000))
                              Q
                              N ) )
                        (T (or (=1 X) (= X N1)))
                        (T
                           (do K
                              (setq X (**Mod X 2 N))
                              (when (=1 X) (throw 'composite))
                              (T (= X N1) T) ) )
                        (throw 'composite) ) )
                  (throw 'composite T) ) ) ) ) ) )
(de gcd (A B)
   (until (=0 B)
      (let M (% A B)
         (setq A B B M) ) )
   (abs A) )
(de g (A)
   (% (+ (% (* A A) N) C) N) )
(de pollard-brent (N)
   (let
      (A (dec N)
         Y (rand 1 (min A 1000000000000000000))
         C (rand 1 (min A 1000000000000000000))
         M (rand 1 (min A 1000000000000000000))
         G 1
         R 1
         Q 1 )
      (ifn (bit? 1 N)
         2
         (loop
            (NIL (=1 G))
            (setq X Y)
            (do R
               (setq Y (g Y)) )
            (zero K)
            (loop
               (NIL (and (> R K) (=1 G)))
               (setq YS Y)
               (do (min M (- R K))
                  (setq
                     Y (g Y)
                     Q (% (* Q (abs (- X Y))) N) ) )
               (setq
                  G (gcd Q N)
                  K (+ K M) )
            )
            (setq R (* R 2)) )
         (when (== G N)
            (loop
               (NIL (> G 1))
               (setq
                  YS (g YS)
                  G (gcd (abs (- X YS)) N) ) ) )
         (if (== G N)
            NIL
            G ) ) ) )
(de factors (N)
   (sort
      (make
         (loop
            (setq N (/ N (link (pollard-brent N))))
            (T (isprime N)) )
         (link N) ) ) )
(de fermat (N)
   (inc (** 2 (** 2 N))) )
(for (N 0 (>= 8 N) (inc N))
   (println N ': (fermat N)) )
(prinl)
(for (N 0 (>= 8 N) (inc N))
   (let N (fermat N)
      (println
         N
         ':
         (if (isprime N) 'PRIME (factors N)) ) ) )
