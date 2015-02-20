(defun word-possible-p (word blocks)
  (cond
    ((= (length word) 0) t)
    ((null blocks) nil)
    (t (let*
         ((c (aref word 0))
          (bs (remove-if-not #'(lambda (b)
                                 (find c b :test #'char-equal))
                             blocks)))
         (some #'identity
               (loop for b in bs
                     collect (word-possible-p
                               (subseq word 1)
                               (remove b blocks))))))))
