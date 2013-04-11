(defmethod frob ((sequence sequence))
  (format t "~&sequence has ~w elements" (length sequence)))

(defmethod frob ((string string))
  (format t "~&the string has ~w elements" (length string)))
