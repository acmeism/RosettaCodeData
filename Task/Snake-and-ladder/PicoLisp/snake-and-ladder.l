(seed (in "/dev/urandom" (rd 8)))
(setq *D
   '((4 14 T) (9 31 T) (17 7) (20 38 T)
      (28 84 T) (40 59 T) (51 67 T) (54 34)
      (62 19) (63 81 T) (64 60) (71 91 T)
      (87 24) (93 73) (95 75) (99 78) ) )
(de players (N)
   (make
      (for I N
         (let P (pack "Player " I)
            (set P 1)
            (link P) ) ) ) )
(de turn (P)
   (use D
      (loop
         (setq D (rand 1 6))
         (prin P " on square " (val P) ", rolls a " D)
         (if (> (+ (val P) D) 100)
            (prinl " but cannot move")
            (set P (+ (val P) D))
            (prinl " and move to square " (val P))
            (when (= (val P) 100)
               (prinl P " wins!")
               (throw 'win) )
            (when (assoc (val P) *D)
               (set P (cadr @))
               (if (cddr @)
                  (prinl "Yay! Landed on ladder. Climb up to " (val P))
                  (prinl "Ooops! Landed on snake. Slither down to " (val P)) ) ) )
         (T (> 6 D))
         (prinl "Rolled a 6 so roll again") ) ) )
(de main (N)
   (let P (players N)
      (catch 'win
         (loop
            (mapc turn P) ) ) ) )
(main 10)
