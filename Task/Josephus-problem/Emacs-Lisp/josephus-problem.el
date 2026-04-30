(defun jo (n k)
  (if (= 1 n)
      1
    (1+ (% (+ (1- k)
              (jo (1- n) k))
           n))))

(message "%d" (jo 50 2))
(message "%d" (jo 60 3))
