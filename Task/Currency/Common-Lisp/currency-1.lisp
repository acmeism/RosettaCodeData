(defun print-$ (rat &key (prefix "") (stream t))
  (multiple-value-bind (dollars cents) (truncate rat)
    (format stream "~A~D.~D~%" prefix dollars (round (* 100 cents)))))

(defun compute-check (order-alist tax-rate)
  (let* ((total-before-tax
           (loop :for (amount . price) in order-alist
                 :sum (* (rationalize price) amount)))
         (tax (* (rationalize tax-rate) total-before-tax)))
    (print-$ total-before-tax         :prefix "Total before tax: ")
    (print-$ tax                      :prefix "Tax:              ")
    (print-$ (+ total-before-tax tax) :prefix "Total with tax:   ")))

(compute-check '((4000000000000000 . 5.5) (2 . 2.86)) 0.0765)
