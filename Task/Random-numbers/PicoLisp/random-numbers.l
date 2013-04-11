(load "@lib/math.l")

(de randomNormal ()  # Normal distribution, centered on 0, std dev 1
   (*/
      (sqrt (* -2.0 (log (rand 0 1.0))))
      (cos (*/ 2.0 pi (rand 0 1.0) `(* 1.0 1.0)))
      1.0 ) )

(seed (time))                                      # Randomize

(let Result
   (make                                           # Build list
      (do 1000                                     # of 1000 elements
         (link (+ 1.0 (/ (randomNormal) 2))) ) )
   (for N (head 7 Result)                          # Print first 7 results
      (prin (format N *Scl) " ") ) )
