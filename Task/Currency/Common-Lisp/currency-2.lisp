(defun read-$ (stream char)
  (declare (ignore char))
  (let* ((str (with-output-to-string (out)
                ;; TODO: read integer, if dot, read dot and another integer
                (loop :for next = (peek-char nil stream t nil t)
                      :while (or (digit-char-p next) (char= next #\.))
                      :do (write-char (read-char stream t nil t) out))))
         (dot-pos (position #\. str))
         (dollars (parse-integer str :end dot-pos))
         (cents (if dot-pos
                    (/ (parse-integer str :start (+ dot-pos 1))
                       (expt 10 (- (length str) (+ dot-pos 1))))
                    0)))
    (+ dollars cents)))
(set-macro-character #\$ #'read-$ t)

(defun print-$ (rat &key (prefix "") (stream t))
  (multiple-value-bind (dollars cents) (truncate rat)
    (format stream "~A~D.~D~%" prefix dollars (round (* 100 cents)))))

(defun compute-check (order-alist tax-rate)
  (let* ((total-before-tax
           (loop :for (amount . price) in order-alist
                 :sum (* price amount)))
         (tax (* (rationalize tax-rate) total-before-tax)))
    (print-$ total-before-tax         :prefix "Total before tax: ")
    (print-$ tax                      :prefix "Tax:              ")
    (print-$ (+ total-before-tax tax) :prefix "Total with tax:   ")))

(compute-check '((4000000000000000 . $5.5) (2 . $2.86)) 0.0765)
