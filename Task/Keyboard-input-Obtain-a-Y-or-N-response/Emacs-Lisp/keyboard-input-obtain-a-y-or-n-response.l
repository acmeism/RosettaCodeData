(defun get-happiness ()
  "Asks for y or n response about happiness.
Returns t if happy; nil otherwise."
  (discard-input)
  (y-or-n-p "Are you happy?"))
