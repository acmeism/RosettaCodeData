(defun ->str
  (((match-complex real r img i)) (when (>= i 0))
   (->str r i "+"))
  (((match-complex real r img i))
   (->str r i "")))

(defun ->str (r i pos)
  (io_lib:format "~p ~s~pi" `(,r ,pos ,i)))

(defun print (cmplx)
  (io:format (++ (->str cmplx) "~n")))
