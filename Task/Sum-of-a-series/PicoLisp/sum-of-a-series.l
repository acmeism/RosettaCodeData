(scl 9)  # Calculate with 9 digits precision

(let S 0
   (for I 1000
      (inc 'S (*/ 1.0 (* I I))) )
   (prinl (round S 6)) )  # Round result to 6 digits
