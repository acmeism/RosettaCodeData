(zero *Split)     # global state

(de mod64 (N)
   (& N `(hex "FFFFFFFFFFFFFFFF")) )
(de mod64+ (A B)
   (mod64 (+ A B)) )
(de mod64* (A B)
   (mod64 (* A B)) )
(de roundf (N)    # rounds down
   (/ N (** 10 *Scl)) )
(de nextSplit ()
   (setq *Split (mod64+ *Split `(hex "9e3779b97f4a7c15")))
   (let Z *Split
      (setq
         Z (mod64* `(hex "bf58476d1ce4e5b9") (x| Z (>> 30 Z)))
         Z (mod64* `(hex "94d049bb133111eb") (x| Z (>> 27 Z))) )
      (x| Z (>> 31 Z)) ) )

(prinl "First 5 numbers:")
(setq *Split 1234567)
(do 5
   (println (nextSplit)) )

(prinl "The counts for 100,000 repetitions are:")
(scl 12)
(off R)
(setq *Split 987654321)
(do 100000
   (accu
      'R
      (roundf (* 5 (*/ (nextSplit) 1.0 18446744073709551616)))
      1 ) )
(mapc println (sort R))
