(defvar *language* :en
  "The language to use for messages (defaults to English)")

(defmacro with-language ((language) &body body)
  "Locally binds *LANGUAGE* to LANGUAGE"
  `(let ((*language* ,language))
     ,@body))

(defgeneric complain% (language about)
  ;; The % indicates this is an “internal” implementation detail.
  (:method ((language (eql :en)) (about (eql :weather)))
     "It's too cold in winter"))

(defun complain (about)
  "Complain about something indicated by ABOUT"
  (princ (complain% *language* about) *error-output*)
  (terpri *error-output*)
  (finish-output *error-output*)
  nil)

(defmethod complain% ((language (eql :es)) (about (eql :weather)))
  "Hace demasiado frío en invierno")


(complain :weather)
(with-language (:es)
  (complain :weather))
(complain :weather)

⇓

It's too cold in winter
Hace demasiado frío en invierno
It's too cold in winter
