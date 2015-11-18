;config-file.lisp
(defstruct config-file :fullname :favoritefruit :needspeeling :seedsremoved :otherfamily)
(with-open-file (in "config-file.txt")
  (defvar contents (read in))
  (format t "~a~%" contents)
  ;reading the config-file into a structure gives us
  ;some helper functions to access individualy each element
  (format t "Fullname: ~a~%" (config-file-fullname contents))
  (format t "Contents is a config-file? ~a~%" (config-file-p contents)))
