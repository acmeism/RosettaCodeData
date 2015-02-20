(defmacro prependf (s &rest strs)
  "Prepend the given string variable with additional strings. The string variable is modified in-place."
  `(setf ,s (concatenate 'string ,@strs ,s)))

(defvar *str* "foo")
(prependf *str* "bar")
(format T "~a~%" *str*)
