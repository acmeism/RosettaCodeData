#!/bin/sh
#|
exec clisp -q -q $0 $0 ${1+"$@"}
|#
