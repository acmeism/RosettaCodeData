; define the empty string
(define empty-string "")

; three simplest tests for 'the-string emptiness
(if (or
      (string-eq? the-string "")
      (string=?   the-string "")
      (eq? (string-length the-string) 0))
   (print "the-string is empty")

; four simplest tests for 'the-string not emptiness
(if (or
      (not (string-eq? the-string ""))
      (not (string=?   the-string ""))
      (not (eq? (string-length the-string) 0))
      (less? 0 (string-length the-string)))
   (print "the-string is NOT empty))
