(defparameter *s* "") ;; Binds dynamic variable *S* to the empty string ""
(let ((s "")) ;; Binds the lexical variable S to the empty string ""
  (= (length s) 0) ;; Check if the string is empty
  (> (length s) 0) ;; Check if length of string is over 0 (that is: non-empty)

  ;; (length s) returns zero for any empty sequence. You're better off using type checking:
  (typep s '(string 0)) ;; only returns true on empty string
  (typep s '(and string
                 (not (string 0)))))  ;; only returns true on string that is not empty
