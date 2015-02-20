(defun magic-square (n)
  (loop for i from 1 to n
        collect
          (loop for j from 1 to n
                collect
                  (+ (* n (mod (+ i j (floor n 2) -1)
                               n))
                     (mod (+ i (* 2 j) -2)
                          n)
                     1))))

(defun magic-constant (n)
  (* n
     (/ (1+ (* n n))
        2)))

(defun output (n)
  (format T "Magic constant for n=~a: ~a~%" n (magic-constant n))
  (let* ((size (length (write-to-string (* n n))))
         (format-str (format NIL "~~{~~{~~~ad~~^ ~~}~~%~~}~~%" size)))
    (format T format-str (magic-square n))))
