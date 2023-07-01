(defun get-code (c)
  (case c
    ((#\B #\F #\P #\V) #\1)
    ((#\C #\G #\J #\K
      #\Q #\S #\X #\Z) #\2)
    ((#\D #\T) #\3)
    (#\L #\4)
    ((#\M #\N) #\5)
    (#\R #\6)))

(defun soundex (s)
  (if (zerop (length s))
    ""
    (let* ((l (coerce (string-upcase s) 'list))
           (o (list (first l))))
      (loop for c in (rest l)
            for cg = (get-code c) and
            for cp = #\Z then cg
            when (and cg (not (eql cg cp))) do
              (push cg o)
            finally
              (return (subseq (coerce (nreverse `(#\0 #\0 #\0 ,@o)) 'string) 0 4))))))
