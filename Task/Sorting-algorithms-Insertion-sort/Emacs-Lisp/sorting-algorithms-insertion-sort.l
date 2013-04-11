(defun min-or-max-of-2-numbers (n1 n2 rel)
  "n1 and n2 are two numbers, rel can be '< or '> according to
what sort of sorting is wanted, this function returns the greater
or smaller number n1 or n2"
  (cond
   ((eval (list rel n1 n2)) n1)
   (t n2)))

(defun min-or-max-of-a-list (lon rel)
  "lon is a list of numbers, rel is '< or '>, this fonction
returns the higher or lower number of the list"
  (if (cdr lon)
      (min-or-max-of-2-numbers (car lon)
			       (min-or-max-of-a-list (cdr lon) rel)
			       rel)
    (car lon)))

(defun remove-number-from-list (n lon)
  "lon is a list of numbers, n is a number belonging to the list,
this function returns the same list but the number n. If n is
present twice or more, it will be removed only once"
  (if lon
      (cond
       ((= (car lon) n) (cdr lon))
       (t (cons (car lon) (remove-number-from-list n (cdr lon)))))
    nil))


(defun sort-insertion (lon rel)
  "lon is a list of numbers, rel can be '< or '>, this function
returns a list containing the same elements but which is sorted
according to rel"
  (if lon
      (cons (min-or-max-of-a-list lon rel)
	    (sort-insertion
	     (remove-number-from-list
	      (min-or-max-of-a-list lon rel)
	      lon)
	     rel))
    nil))

;;; let's try it :

(sort-insertion (list 1 2 3 9 8 7 25 12 3 2 1) '>)
