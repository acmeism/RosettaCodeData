(defun nonempty (seq)
  (position-if (lambda (x) (declare (ignore x)) t) seq))

(defun split (delim seq)
  "Splits seq on delim into a list of subsequences. Trailing empty
subsequences are removed."
  (labels
      ((f (seq &aux (pos (position delim seq)))
         (if pos
             (cons
              (subseq seq 0 pos)
              (f (subseq seq (1+ pos))))
           (list seq))))
    (let* ((list (f seq))
           (end (position-if #'nonempty list :from-end t)))
      (subseq list 0 (1+ end)))))

(defun lengthen (list minlen filler-elem &aux (len (length list)))
  "Destructively pads list with filler-elem up to minlen."
  (if (< len minlen)
      (nconc list (make-list (- minlen len) :initial-element filler-elem))
    list))

(defun align-columns (text
                      &key (align :left)
                      &aux
                      (fmtmod (case align
                                (:left "@")
                                (:right ":")
                                (:center "@:")
                                (t (error "Invalid alignment."))))
                      (fields (mapcar (lambda (line) (split #\$ line))
                                      (split #\Newline text)))
                      (mostcols (loop for l in fields
                                      maximize (length l)))
                      widest)
  (setf fields (mapcar (lambda (l) (lengthen l mostcols ""))
                       fields))
  (setf widest (loop for col below (length (first fields))
                     collect (loop for row in fields
                                   maximize (length (elt row col)))))
  (format nil
          (with-output-to-string (s)
            (princ "~{~{" s)
            (dolist (w widest)
              (format s "~~~d~a<~~a~~>" (1+ w) fmtmod))
            (princ "~}~%~}" s))
          fields))
