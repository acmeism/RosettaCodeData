(defun make-heap (&optional (length 7))
  (make-array length :adjustable t :fill-pointer 0))

(defun left-index (index)
  (1- (* 2 (1+ index))))

(defun right-index (index)
  (* 2 (1+ index)))

(defun parent-index (index)
  (floor (1- index) 2))

(defun percolate-up (heap index predicate)
  (if (zerop index) heap
    (do* ((element (aref heap index))
          (index index pindex)
          (pindex (parent-index index)
                  (parent-index index)))
         ((zerop index) heap)
      (if (funcall predicate element (aref heap pindex))
        (rotatef (aref heap index) (aref heap pindex))
        (return-from percolate-up heap)))))

(defun heap-insert (heap element predicate)
  (let ((index (vector-push-extend element heap 2)))
    (percolate-up heap index predicate)))

(defun percolate-down (heap index predicate)
  (let ((length (length heap))
        (element (aref heap index)))
    (flet ((maybe-element (index)
             "return the element at index or nil, and a boolean
              indicating whether there was an element."
             (if (< index length)
               (values (aref heap index) t)
               (values nil nil))))
      (do ((index index swap-index)
           (lindex (left-index index) (left-index index))
           (rindex (right-index index) (right-index index))
           (swap-index nil) (swap-child nil))
          (nil)
        ;; Extact the left child if there is one. If there is not,
        ;; return the heap.  Set the left child as the swap-child.
        (multiple-value-bind (lchild lp) (maybe-element lindex)
          (if (not lp) (return-from percolate-down heap)
            (setf swap-child lchild
                  swap-index lindex))
          ;; Extract the right child, if any, and when better than the
          ;; current swap-child, update the swap-child.
          (multiple-value-bind (rchild rp) (maybe-element rindex)
            (when (and rp (funcall predicate rchild lchild))
              (setf swap-child rchild
                    swap-index rindex))
            ;; If the swap-child is better than element, rotate them,
            ;; and continue percolating down, else return heap.
            (if (not (funcall predicate swap-child element))
              (return-from percolate-down heap)
              (rotatef (aref heap index) (aref heap swap-index)))))))))

(defun heap-empty-p (heap)
  (eql (length heap) 0))

(defun heap-delete-min (heap predicate)
  (assert (not (heap-empty-p heap)) () "Can't pop from empty heap.")
  (prog1 (aref heap 0)
    (setf (aref heap 0) (vector-pop heap))
    (unless (heap-empty-p heap)
      (percolate-down heap 0 predicate))))

(defun heapsort (sequence predicate)
  (let ((h (make-heap (length sequence))))
    (map nil #'(lambda (e) (heap-insert h e predicate)) sequence)
    (map-into sequence #'(lambda () (heap-delete-min h predicate)))))
