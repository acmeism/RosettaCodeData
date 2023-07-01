(string-delimiter "")

(for ((i (in-range 1 11))) (write i) #:break (= i 10) (write ","))
 → 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10

;; or

(string-join (range 1 11) ",")
   → 1,2,3,4,5,6,7,8,9,10
