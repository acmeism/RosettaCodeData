(defun jo(n k)
  (if (= 1 n) 1 (1+ (% (+ (1- k)
			  (jo (1- n) k)) n ) ) ))
(princ-list (jo 50 2) "\n" (jo 60 3))
