#!/bin/sh
#|
exec clisp -q -q $0 $0 ${1+"$@"}
exit
|#

;;; Usage: ./scriptedmain.lisp

(defun meaning-of-life () 42)

(defun main (args)
 (format t "Main: The meaning of life is ~a~%" (meaning-of-life))
 (quit))

;;; With help from Francois-Rene Rideau
;;; http://tinyurl.com/cli-args
(let ((args
       #+clisp ext:*args*
       #+sbcl sb-ext:*posix-argv*
       #+clozure (ccl::command-line-arguments)
       #+gcl si:*command-args*
       #+ecl (loop for i from 0 below (si:argc) collect (si:argv i))
       #+cmu extensions:*command-line-strings*
       #+allegro (sys:command-line-arguments)
       #+lispworks sys:*line-arguments-list*
     ))

  (if (member (pathname-name *load-truename*)
              args
              :test #'(lambda (x y) (search x y :test #'equalp)))
    (main args)))
