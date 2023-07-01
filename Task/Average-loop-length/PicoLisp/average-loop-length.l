(scl 4)
(seed (in "/dev/urandom" (rd 8)))

(de fact (N)
   (if (=0 N) 1 (apply * (range 1 N))) )

(de analytical (N)
   (sum
      '((I)
         (/
            (* (fact N) 1.0)
            (** N I)
            (fact (- N I)) ) )
      (range 1 N) ) )

(de testing (N)
   (let (C 0  N (dec N)  X 0  B 0  I 1000000)
      (do I
         (zero B)
         (one X)
         (while (=0 (& B X))
            (inc 'C)
            (setq
               B (| B X)
               X (** 2 (rand 0 N)) ) ) )
      (*/ C 1.0 I) ) )

(let F (2 8 8 6)
   (tab F "N" "Avg" "Exp" "Diff")
   (for I 20
      (let (A (testing I)  B (analytical I))
         (tab F
            I
            (round A 4)
            (round B 4)
            (round
               (*
                  (abs (- (*/ A 1.0 B) 1.0))
                  100 )
               2 ) ) ) ) )

(bye)
