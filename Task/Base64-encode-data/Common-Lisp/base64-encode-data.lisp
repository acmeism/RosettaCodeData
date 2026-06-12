(eval-when (:load-toplevel :compile-toplevel :execute)
  (ql:quickload "drakma")
  (ql:quickload "cl-base64"))

;; * The package definition
(defpackage :base64-encode
  (:use :common-lisp :drakma :cl-base64))
(in-package :base64-encode)

;; * The function
(defun base64-encode (&optional (uri "https://rosettacode.org/favicon.ico"))
  "Returns the BASE64 encoded string of the file at URI."
    (let* ((input (http-request uri :want-stream t))
        (output (loop
                   with array = (make-array 0 :element-type 'unsigned-byte
                                              :adjustable t :fill-pointer 0)
                   for data-chunk = (read-byte input nil nil)
                   while data-chunk
                   do (vector-push-extend data-chunk array)
                   finally (return (usb8-array-to-base64-string array)))))
   (close input)
   output))
