(setq *A (chop "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"))
(setq *K (chop "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN"))

(de cipher (Str D)
   (let (K *K  A *A)
      (and D (xchg 'A 'K))
      (pack
         (mapcar
            '((N)
               (or
                  (pick
                     '((A K) (and (= A N) K))
                     A
                     K )
                  N ) )
            (chop Str) ) ) ) )
(and
   (println 'encode (cipher "The quick brown fox jumped over the lazy dog's back"))
   (println 'decode (cipher @ T)) )
