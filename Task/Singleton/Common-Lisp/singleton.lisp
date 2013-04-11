(defgeneric concat (a b)
  (:documentation "Concatenate two phrases."))

(defclass nonempty-phrase ()
  ((text :initarg :text :reader text)))

(defmethod concat ((a nonempty-phrase) (b nonempty-phrase))
  (make-instance 'nonempty-phrase :text (concatenate 'string (text a) " " (text b))))

(defmethod concat ((a (eql 'the-empty-phrase)) b)
  b)

(defmethod concat (a (b (eql 'the-empty-phrase)))
  a)

(defun example ()
  (let ((before (make-instance 'nonempty-phrase :text "Jack"))
        (mid (make-instance 'nonempty-phrase :text "went"))
        (after (make-instance 'nonempty-phrase :text "to fetch a pail of water")))
    (dolist (p (list 'the-empty-phrase
                     (make-instance 'nonempty-phrase :text "and Jill")))
      (dolist (q (list 'the-empty-phrase
                       (make-instance 'nonempty-phrase :text "up the hill")))
        (write-line (text (reduce #'concat (list before p mid q after))))))))
