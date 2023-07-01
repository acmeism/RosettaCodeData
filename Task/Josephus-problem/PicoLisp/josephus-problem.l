#general solution
(de jo (N K)
   (if (=1 N)
      1
      (inc
         (%
            (+ (dec K) (jo (dec N) K))
            N ) ) ) )

#special case when K is 2; much faster than general version.
(de jo2(N)
   (let P 1
      (while (<= P N)
         (setq P (* 2 P))
         (+ (- (* 2 N) P) 1) ) ) )

# find the survivor using an optimal solution
(de survivor (N K)
   (if (=0 (% N 2))
      (jo2 N)
      (jo N K) ) )
(print (survivor 5 2))
(print (survivor 41 3))
