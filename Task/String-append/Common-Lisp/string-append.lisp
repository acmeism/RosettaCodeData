(defmacro concatenatef (s &rest strs)
  "Append additional strings to the first string in-place."
  `(setf ,s (concatenate 'string ,s ,@strs)))
(defvar *str* "foo")
(concatenatef *str* "bar")
(format T "~a~%" *str*)
(concatenatef *str* "baz" "abc" "def")
(format T "~a~%" *str*)
