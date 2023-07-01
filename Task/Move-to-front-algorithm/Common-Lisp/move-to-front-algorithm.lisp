(defconstant +lower+ (coerce "abcdefghijklmnopqrstuvwxyz" 'list))

(defun move-to-front (x xs)
  (cons x (remove x xs)))

(defun enc (text table)
  (map 'list
       (lambda (c)
               (let ((idx (position c table)))
                 (setf table (move-to-front c table))
                 idx))
       text))

(defun dec (indices table)
    (coerce (mapcar (lambda (idx)
                      (let ((c (nth idx table)))
                        (setf table (move-to-front c table))
                        c))
                    indices)
            'string))

(loop for word in '("broood" "bananaaa" "hiphophiphop")
      do (let* ((encoded (enc word +lower+))
                (decoded (dec encoded +lower+)))
           (assert (string= word decoded))
           (format T "~s encodes to ~a which decodes back to ~s.~%"
                   word encoded decoded)))
