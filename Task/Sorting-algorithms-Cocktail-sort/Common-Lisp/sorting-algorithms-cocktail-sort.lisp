(defun cocktail-sort-vector (vector predicate &aux (len (length vector)))
  (labels ((scan (start step &aux swapped)
             (loop for i = start then (+ i step) while (< 0 i len) do
               (when (funcall predicate (aref vector i)
                                        (aref vector (1- i)))
                 (rotatef (aref vector i)
                          (aref vector (1- i)))
                 (setf swapped t)))
             swapped))
    (loop while (and (scan 1         1)
                     (scan (1- len) -1))))
  vector)

(defun cocktail-sort (sequence predicate)
  (etypecase sequence
    (vector (cocktail-sort-vector sequence predicate))
    (list (map-into sequence 'identity
                    (cocktail-sort-vector (coerce sequence 'vector)
                                          predicate)))))
