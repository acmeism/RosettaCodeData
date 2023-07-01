(de dice5 ()
   (rand 1 5) )

(de dice7 ()
   (use R
      (until (> 21 (setq R (+ (* 5 (dice5)) (dice5) -6))))
      (inc (% R 7)) ) )
