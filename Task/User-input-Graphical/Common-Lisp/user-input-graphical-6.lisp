(defun do-prompting ()
  (capi:popup-confirmer
   (make-instance 'string/integer-prompt)
   "Enter some values:"
   :value-function 'string/integer-prompt-value
   :ok-check #'(lambda (result) (eql (cdr result) 75000))))
