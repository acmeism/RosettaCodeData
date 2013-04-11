(defparameter *s* "hello")
(print (concatenate 'string *s* " literal"))
(defparameter *s1* (concatenate 'string *s* " literal"))
(print *s1*)
