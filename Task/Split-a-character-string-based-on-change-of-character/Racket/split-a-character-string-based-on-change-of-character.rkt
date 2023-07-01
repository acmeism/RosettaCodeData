#lang racket
(define (split-strings-on-change s)
  (map list->string (group-by values (string->list s) char=?)))

(displayln (string-join (split-strings-on-change #<<<
gHHH5YY++///\
<
                                                 )
                        ", "))
