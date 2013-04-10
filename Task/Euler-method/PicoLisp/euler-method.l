(load "@lib/math.l")

(de euler (F Y A B H)
   (while (> B A)
      (prinl (round A) " " (round Y))
      (inc 'Y (*/ H (F A Y) 1.0))
      (inc 'A H) ) )

(de newtonCoolingLaw (A B)
   (*/ -0.07 (- B 20.) 1.0) )

(euler newtonCoolingLaw 100.0 0 100.0 2.0)
(euler newtonCoolingLaw 100.0 0 100.0 5.0)
(euler newtonCoolingLaw 100.0 0 100.0 10.0)
