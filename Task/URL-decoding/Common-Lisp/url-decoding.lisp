(defun decode (string &key start)
  (assert (char= (char string start) #\%))
  (if (>= (length string) (+ start 3))
      (multiple-value-bind (code pos)
          (parse-integer string :start (1+ start) :end (+ start 3) :radix 16 :junk-allowed t)
        (if (= pos (+ start 3))
            (values (code-char code) pos)
            (values #\% (1+ start))))
      (values #\% (1+ start))))

(defun url-decode (url)
  (loop with start = 0
        for pos = (position #\% url :start start)
        collect (subseq url start pos) into chunks
        when pos
          collect (multiple-value-bind (decoded next) (decode url :start pos)
                    (setf start next)
                    (string decoded))
            into chunks
        while pos
        finally (return (apply #'concatenate 'string chunks))))

(url-decode "http%3A%2F%2Ffoo%20bar%2F")
