(defparameter *s* "") ;; Binds dynamic variable *S* to the empty string ""
(let ((s "")) ;; Binds the lexical variable S to the empty string ""
  (= (length s) 0) ;; Check if the string is empty
  (> (length s) 0)) ;; Check if length of string is over 0 (that is: non-empty)
