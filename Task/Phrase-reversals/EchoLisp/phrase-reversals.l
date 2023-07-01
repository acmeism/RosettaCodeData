(define (string-reverse string)
    (list->string (reverse (string->list string))))

(define (task str)
    (for-each writeln (list
      (string-reverse str)
      (string-join (map string-reverse (string-split str )))
      (string-join (reverse (string-split str ))))))


(task "rosetta code phrase reversal")
    "lasrever esarhp edoc attesor"
    "attesor edoc esarhp lasrever"
    "reversal phrase code rosetta"
