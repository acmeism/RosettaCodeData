(defun bottles (x)
  (loop for bottles from x downto 1
        do (format t "~a bottle~:p of beer on the wall
~:*~a bottle~:p of beer
Take one down, pass it around
~a bottle~:p of beer on the wall~2%" bottles (1- bottles))))
