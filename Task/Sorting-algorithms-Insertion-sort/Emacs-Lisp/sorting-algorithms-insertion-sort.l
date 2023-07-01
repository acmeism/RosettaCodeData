(defun min-or-max-of-a-list (numbers comparator)
  "Return minimum or maximum of NUMBERS using COMPARATOR."
  (let ((extremum (car numbers)))
    (dolist (n (cdr numbers))
      (when (funcall comparator n extremum)
        (setq extremum n)))
    extremum))

(defun remove-number-from-list (numbers n)
  "Return NUMBERS without N.
If n is present twice or more, it will be removed only once."
  (let (result)
    (while numbers
      (let ((number (pop numbers)))
        (if (= number n)
            (while numbers
              (push (pop numbers) result))
          (push number result))))
    (nreverse result)))

(defun insertion-sort (numbers comparator)
  "Return sorted list of NUMBERS using COMPARATOR."
  (if numbers
      (let ((extremum (min-or-max-of-a-list numbers comparator)))
        (cons extremum
	      (insertion-sort (remove-number-from-list numbers extremum)
                              comparator)))
    nil))

(insertion-sort '(1 2 3 9 8 7 25 12 3 2 1) #'>)
