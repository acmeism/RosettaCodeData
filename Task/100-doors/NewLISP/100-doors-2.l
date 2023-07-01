(set 'Doors (array 100))  ;; Default value: nil (Closed)

(for (x 0 99)
    (for (y x 99 (+ 1 x))
        (setf (Doors y) (not (Doors y)))))

(for (x 0 99)  ;; Display open doors
    (if (Doors x)
        (println (+ x 1) " : Open")))
