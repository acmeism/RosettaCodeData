(defun starts-with-p (str1 str2)
  "Determine whether `str1` starts with `str2`"
  (let ((p (search str2 str1)))
    (and p (= 0 p))))

(print (starts-with-p "foobar" "foo")) ; T
(print (starts-with-p "foobar" "bar")) ; NIL

(defun ends-with-p (str1 str2)
  "Determine whether `str1` ends with `str2`"
  (let ((p (mismatch str2 str1 :from-end T)))
    (or (not p) (= 0 p))))

(print (ends-with-p "foobar" "foo")) ; NIL
(print (ends-with-p "foobar" "bar")) ; T

(defun containsp (str1 str2)
  "Determine whether `str1` contains `str2`.
   Instead of just returning T, return a list of starting locations
   for every occurence of `str2` in `str1`"
   (unless (string-equal str2 "")
     (loop for p = (search str2 str1) then (search str2 str1 :start2 (1+ p))
           while p
           collect p)))

(print (containsp "foobar" "oba")) ; (2)
(print (containsp "ababaBa" "ba")) ; (1 3)
(print (containsp "foobar" "x"))   ; NIL
