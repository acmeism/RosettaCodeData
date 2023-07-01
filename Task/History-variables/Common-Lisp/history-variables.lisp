(defmacro make-hvar (value)
  `(list ,value))

(defmacro get-hvar (hvar)
  `(car ,hvar))

(defmacro set-hvar (hvar value)
  `(push ,value ,hvar))

;; Make sure that setf macro can be used
(defsetf get-hvar set-hvar)

(defmacro undo-hvar (hvar)
  `(pop ,hvar))

(let ((v (make-hvar 1)))
  (format t "Initial value = ~a~%" (get-hvar v))
  (set-hvar v 2)
  (setf (get-hvar v) 3) ;; Alternative using setf
  (format t "Current value = ~a~%" (get-hvar v))
  (undo-hvar v)
  (undo-hvar v)
  (format t "Restored value = ~a~%" (get-hvar v)))
