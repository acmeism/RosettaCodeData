(defun factorial (n)
  (loop for result = 1 then (* i result)
        for i from 2 to n
        finally (return result)))

(defun nth-permutation (k sequence)
  (if (zerop (length sequence))
      (coerce () (type-of sequence))
      (let ((seq (etypecase sequence
                   (vector (copy-seq sequence))
                   (sequence (coerce sequence 'vector)))))
        (loop for j from 2 to (length seq)
              do (setq k (truncate (/ k (1- j))))
              do (rotatef (aref seq (mod k j))
                          (aref seq (1- j)))
              finally (return (coerce seq (type-of sequence)))))))

(defun sortedp (fn sequence)
  (etypecase sequence
    (list (loop for previous = #1='#:foo then i
                for i in sequence
                always (or (eq previous #1#)
                           (funcall fn i previous))))
    ;; copypasta
    (vector (loop for previous = #1# then i
                  for i across sequence
                  always (or (eq previous #1#)
                             (funcall fn i previous))))))

(defun permutation-sort (fn sequence)
  (loop for i below (factorial (length sequence))
        for permutation = (nth-permutation i sequence)
        when (sortedp fn permutation)
          do (return permutation)))
