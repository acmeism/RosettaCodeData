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
(for N 1000
   (and
      (isprime (dec (** 2 N)))
      (prinl "2 \^ " N " - 1") ) )
