; file:   ocount.lsp
; url:    http://rosettacode.org/wiki/Count_in_octal
; author: oofoe 2012-01-29

; Although NewLISP itself uses a 64-bit integer representation, the
; format function relies on underlying C library's printf function,
; which can only handle a 32-bit octal number on this implementation.

(for (i 0 (pow 2 32)) (println (format "%o" i)))

(exit)
