(defn gamma
  "Returns Gamma(z + 1 = number) using Lanczos approximation."
  [number]
  (if (< number 0.5)
       (/ Math/PI (* (Math/sin (* Math/PI number))
	             (gamma (- 1 number))))
       (let [n (dec number)
      	     c [0.99999999999980993 676.5203681218851 -1259.1392167224028
	        771.32342877765313 -176.61502916214059 12.507343278686905
	        -0.13857109526572012 9.9843695780195716e-6 1.5056327351493116e-7]]
         (* (Math/sqrt (* 2 Math/PI))
	    (Math/pow (+ n 7 0.5) (+ n 0.5))
	    (Math/exp (- (+ n 7 0.5)))
            (+ (first c)
               (apply + (map-indexed #(/ %2 (+ n %1 1)) (next c))))))))
