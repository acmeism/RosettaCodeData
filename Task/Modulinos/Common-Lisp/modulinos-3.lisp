#!/bin/sh
#|
exec clisp -q -q $0 $0 ${1+"$@"}
exit
|#

(load "scriptedmain.lisp")
(format t "Test: The meaning of life is ~a~%" (meaning-of-life))
