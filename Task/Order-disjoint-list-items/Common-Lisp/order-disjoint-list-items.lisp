(defun order-disjoint (data order)
  (let ((order-b (make-hash-table :test 'equal)))
    (loop :for n :in order :do (incf (gethash n order-b 0)))
    (loop :for m :in data :collect
       (cond ((< 0 (gethash m order-b 0))
              (decf (gethash m order-b))
              (pop order))
             (t m)))))
