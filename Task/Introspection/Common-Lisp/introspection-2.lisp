(defvar bloop -4)
(if (and (fboundp 'abs)
         (boundp 'bloop))
    (format t "~d~%" (abs bloop)))
