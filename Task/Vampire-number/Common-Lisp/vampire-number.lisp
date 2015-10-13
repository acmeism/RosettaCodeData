(defun trailing-zerop (number)
  "Is the lowest digit of `number' a 0"
  (zerop (rem number 10)))

(defun integer-digits (integer)
  "Return the number of digits of the `integer'"
  (assert (integerp integer))
  (length (write-to-string integer)))

(defun paired-factors (number)
  "Return a list of pairs that are factors of `number'"
  (loop
    :for candidate :from 2 :upto (sqrt number)
    :when (zerop (mod number candidate))
      :collect (list candidate (/ number candidate))))

(defun vampirep (candidate &aux
                             (digits-of-candidate (integer-digits candidate))
                             (half-the-digits-of-candidate (/ digits-of-candidate
                                                              2)))
  "Is the `candidate' a vampire number?"
  (remove-if #'(lambda (pair)
                 (> (length (remove-if #'null (mapcar #'trailing-zerop pair)))
                     1))
             (remove-if-not #'(lambda (pair)
                                (string= (sort (copy-seq (write-to-string candidate))
                                               #'char<)
                                         (sort (copy-seq (format nil "~A~A" (first pair) (second pair)))
                                               #'char<)))
                            (remove-if-not #'(lambda (pair)
                                               (and (eql (integer-digits (first pair))
                                                         half-the-digits-of-candidate)
                                                    (eql (integer-digits (second pair))
                                                         half-the-digits-of-candidate)))
                                           (paired-factors candidate)))))

(defun print-vampire (candidate fangs &optional (stream t))
  (format stream
          "The number ~A is a vampire number with fangs: ~{ ~{~A~^, ~}~^; ~}~%"
          candidate
          fangs))

;; Print the first 25 vampire numbers

(loop
  :with count := 0
  :for candidate :from 0
  :until (eql count 25)
  :for fangs := (vampirep candidate)
  :do
     (when fangs
       (print-vampire candidate fangs)
       (incf count)))

;; Check if 16758243290880, 24959017348650, 14593825548650 are vampire numbers

(dolist (candidate '(16758243290880 24959017348650 14593825548650))
  (let ((fangs (vampirep candidate)))
    (when fangs
      (print-vampire candidate fangs))))
