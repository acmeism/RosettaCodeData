(defun calculate-distribution (numbers)
  "Return the frequency distribution of the most significant nonzero
   digits in the given list of numbers. The first element of the list
   is the frequency for digit 1, the second for digit 2, and so on."

  (defun nonzero-digit-p (c)
    "Check whether the character is a nonzero digit"
    (and (digit-char-p c) (char/= c #\0)))

  (defun first-digit (n)
    "Return the most significant nonzero digit of the number or NIL if
     there is none."
    (let* ((s (write-to-string n))
           (c (find-if #'nonzero-digit-p s)))
      (when c
        (digit-char-p c))))

  (let ((tally (make-array 9 :element-type 'integer :initial-element 0)))
    (loop for n in numbers
          for digit = (first-digit n)
          when digit
          do (incf (aref tally (1- digit))))
    (loop with total = (length numbers)
          for digit-count across tally
          collect (/ digit-count total))))

(defun calculate-benford-distribution ()
  "Return the frequency distribution according to Benford's law.
   The first element of the list is the probability for digit 1, the second
   element the probability for digit 2, and so on."
  (loop for i from 1 to 9
        collect (log (1+ (/ i)) 10)))

(defun benford (numbers)
  "Print a table of the actual and expected distributions for the given
   list of numbers."
  (let ((actual-distribution (calculate-distribution numbers))
        (expected-distribution (calculate-benford-distribution)))
    (write-line "digit actual expected")
    (format T "~:{~3D~9,3F~8,3F~%~}"
            (map 'list #'list '(1 2 3 4 5 6 7 8 9)
                              actual-distribution
                              expected-distribution))))
