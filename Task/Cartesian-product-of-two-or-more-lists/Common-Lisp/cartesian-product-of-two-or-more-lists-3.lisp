(defun n-cartesian-product (l)
  "Compute the n-cartesian product of a list of sets (each of them represented as list).
   Algorithm:
     If there are no sets, then produce an empty set of tuples;
     otherwise, for all the elements x of the first set, concatenate the sets obtained by
     inserting x at the beginning of each tuple of the n-cartesian product of the remaining sets."
  (if (null l)
      (list nil)
      (loop for x in (car l)
            nconc (loop for y in (n-cartesian-product (cdr l))
                        collect (cons x y)))))
