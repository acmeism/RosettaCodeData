#!/bin/sh
#|
exec csi -ss $0 ${1+"$@"}
exit
|#
(define (main args)
	(load "scriptedmain.scm")
	(display (format "Test: The meaning of life is ~a\n" (meaning-of-life)))
	(exit))
