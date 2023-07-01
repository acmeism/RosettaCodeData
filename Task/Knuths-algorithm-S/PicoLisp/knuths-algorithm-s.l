(de s_of_n_creator (@N)
   (curry (@N (I . 0) (Res)) (Item)
      (cond
         ((>= @N (inc 'I)) (push 'Res Item))
         ((>= @N (rand 1 I)) (set (nth Res (rand 1 @N)) Item)) )
      Res ) )

(let Freq (need 10 0)
   (do 100000
      (let S_of_n (s_of_n_creator 3)
         (for I (mapc S_of_n (0 1 2 3 4 5 6 7 8 9))
            (inc (nth Freq (inc I))) ) ) )
   Freq )
