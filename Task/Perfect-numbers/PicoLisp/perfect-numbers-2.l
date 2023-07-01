(de faster (N)
   (let (C 1  Stop (sqrt N))
      (for (I 2 (<= I Stop) (inc I))
         (and
            (=0 (% N I))
            (inc 'C (+ (/ N I) I)) ) )
      (= C N) ) )
