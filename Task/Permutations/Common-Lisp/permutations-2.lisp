(defun next-perm (vec cmp)  ; modify vector
  (declare (type (simple-array * (*)) vec))
  (macrolet ((el (i) `(aref vec ,i))
             (cmp (i j) `(funcall cmp (el ,i) (el ,j))))
    (loop with len = (1- (length vec))
       for i from (1- len) downto 0
       when (cmp i (1+ i)) do
         (loop for k from len downto i
            when (cmp i k) do
              (rotatef (el i) (el k))
              (setf k (1+ len))
              (loop while (< (incf i) (decf k)) do
                   (rotatef (el i) (el k)))
              (return-from next-perm vec)))))

;;; test code
(loop for a = "1234" then (next-perm a #'char<) while a do
     (write-line a))
