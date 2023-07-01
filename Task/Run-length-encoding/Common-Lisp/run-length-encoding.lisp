(defun group-similar (sequence &key (test 'eql))
  (loop for x in (rest sequence)
        with temp = (subseq sequence 0 1)
        if (funcall test (first temp) x)
          do (push x temp)
        else
          collect temp
          and do (setf temp (list x))))

(defun run-length-encode (sequence)
  (mapcar (lambda (group) (list (first group) (length group)))
          (group-similar (coerce sequence 'list))))

(defun run-length-decode (sequence)
  (reduce (lambda (s1 s2) (concatenate 'simple-string s1 s2))
          (mapcar (lambda (elem)
                    (make-string (second elem)
                                 :initial-element
                                 (first elem)))
                  sequence)))

(run-length-encode "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
(run-length-decode '((#\W 12) (#\B 1) (#\W 12) (#\B 3) (#\W 24) (#\B 1)))
