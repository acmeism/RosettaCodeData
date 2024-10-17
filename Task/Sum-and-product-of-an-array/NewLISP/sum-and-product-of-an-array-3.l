;; 2-dimensional array.
(let (ary2d (array 4 5 (sequence 1 9 0.25)))
  (dolist (row ary2d)
    (print "Row " $idx ": ")
    (dolist (x row) (print (format "%6.2f" x)))
    (println))
  (println)
  (println (apply add (flat (array-list ary2d))))
  (println (apply mul (flat (array-list ary2d)))))
