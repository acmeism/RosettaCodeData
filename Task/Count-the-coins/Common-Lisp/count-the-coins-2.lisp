(defun count-change (amount coins &aux (ways (make-array (1+ amount) :initial-element 0)))
  (setf (aref ways 0) 1)
  (loop for coin in coins do
        (loop for j from coin upto amount
              do (incf (aref ways j) (aref ways (- j coin)))))
  (aref ways amount))
