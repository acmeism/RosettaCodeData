#!/bin/sh
#| -*- scheme -*-
# this is sh code
echo running "$0", passing it into itself as an argument
exec racket -tm "$0" "$0"
|#

#lang racket

(provide main)
(define (main arg)
  (printf "argument: ~a\nexecuted as: ~a\n"
          arg (find-system-path 'exec-file)))
