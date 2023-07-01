(setq *MsSeed 11982)

(de msRand ()
   (>> 16
      (setq *MsSeed
         (& (+ 2531011 (* 214013 *MsSeed)) `(dec (** 2 31))) ) ) )

(let L
   (make
      (for Num (range 13 1)
         (for Suit '((32 . "♠") (31 . "♥") (31 . "♦") (32 . "♣"))
            (link (cons (get '`(chop "A23456789TJQK") Num) Suit)) ) ) )
   (for I 51
      (xchg
         (nth L I)
         (nth L (- 52 (% (msRand) (- 53 I)))) ) )
   (for C L
      (prin "  ^[[" (cadr C) "m" (cddr C) "^[[m" (car C))
      (at (0 . 8) (prinl)) )
   (prinl) )
