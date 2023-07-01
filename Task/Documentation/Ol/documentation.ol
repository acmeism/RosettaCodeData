; note: use this script to generate a markdown file
; sed -n 's/\s*;!\s*//gp'

(import (owl parse))

;! # Documentation

;! ## Functions

;! ### whitespace
;! Returns a #true if argument is a space, newline, return or tab character.
   (define whitespace (byte-if (lambda (x) (has? '(#\tab #\newline #\space #\return) x))))

;! ### maybe-whitespaces
;! Returns any amount (including 0) of whitespaces. Used as whitespace characters skipper in parses.
   (define maybe-whitespaces (greedy* whitespace))
