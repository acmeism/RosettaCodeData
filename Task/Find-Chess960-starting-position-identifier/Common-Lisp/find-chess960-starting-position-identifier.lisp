; make sure string is a valid Chess960 starting array
(defun valid-array-p (start-array)
   (and (string-equal (sort (copy-seq start-array) #'string-lessp) "BBKNNQRR") ; right pieces
        (not (equal (mod (position #\B start-array) 2)                         ; bishops on opposite colors
                    (mod (position #\B start-array :from-end t) 2)))
        (< (position #\R start-array) (position #\K start-array))              ; king between two rooks
        (< (position #\K start-array) (position #\R start-array :from-end t))))

; find Start Position IDentifier for a Chess960 setup
(defun sp-id (start-array)
   (if (not (valid-array-p start-array))
      -1
     (let* ((bishopless   (remove #\B start-array))
            (queenless    (remove #\Q bishopless))
            (n5n-pattern  (substitute-if-not #\- (lambda (ch) (eql ch #\N)) queenless))
            (n5n-table   '("NN---" "N-N--" "N--N-" "N---N" "-NN--" "-N-N-" "-N--N" "--NN-" "--N-N" "---NN"))
            (knights      (position n5n-pattern n5n-table :test #'string-equal))
            (queen        (position #\Q bishopless))
            (left-bishop  (position #\B start-array))
            (right-bishop (position #\B start-array :from-end t)))

       ; map each bishop to its color complex and position within those four squares
       (destructuring-bind (dark-bishop light-bishop)
         (mapcar (lambda (p) (floor p 2))
           (cond ((zerop (mod left-bishop 2)) (list left-bishop  right-bishop))
                  (t                          (list right-bishop left-bishop))))

           (+ (* 96 knights) (* 16 queen) (* 4 dark-bishop) light-bishop)))))

(loop for ary in '("RNBQKBNR" "QNRBBNKR" "RQNBBKRN" "RNQBBKRN") doing
  (format t "~a: ~a~%" ary (sp-id ary)))
