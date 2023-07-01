(de propdiv (N)
   (cdr
      (rot
         (make
            (for I N
               (and (=0 (% N I)) (link I)) ) ) ) ) )
(de countdiv (N)
   (let C -1
      (for I N
         (and (=0 (% N I)) (inc 'C)) )
      C ) )
(let F (-5 -8)
   (tab F "N" "LIST")
   (for I 10
      (tab F
         I
         (glue " + " (propdiv I)) ) ) )
(println
   (maxi
      countdiv
      (range 1 20000) ) )
