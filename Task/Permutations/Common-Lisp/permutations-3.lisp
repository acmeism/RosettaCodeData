(defun heap-permutations (seq)
  (let ((permutations nil))
    (labels ((permute (seq k)
	       (if (= k 1)
		   (push seq permutations)
		   (progn
		     (permute seq (1- k))
		     (loop for i from 0 below (1- k) do
			  (if (evenp k)
			      (rotatef (elt seq i) (elt seq (1- k)))
			      (rotatef (elt seq 0) (elt seq (1- k))))
			  (permute seq (1- k)))))))
      (permute seq (length seq))
      permutations)))
