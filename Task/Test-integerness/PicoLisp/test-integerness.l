(de int? (N)
  (= N (* 1.0 (/ N 1.0)))) #returns T or NIL

(de integer? (N)
  (and (= N (* 1.0 (/ N 1.0))) N)) #returns value of N or NIL

(scl 4) #-> 4 # *Scl the global which holds
1.0 #-> 10000
(int? 1.0) #-> T
(int? 1) #-> NIL # 1 with a scale of 4 is same as 0.0001 which is not an Integer
(int? -1.0) #-> T
(int? -0.0) #-> T
(int? "RE") #-> "RE" -- Number expected
(int? (*/ 2.0 1.0 3.0)) #-> NIL # 6667 is not an integer of the scale of 4, use of */ because of the scale
