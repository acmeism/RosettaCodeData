; fast
(define (string-repeat n str)
  (apply string-append (make-list n str)))
(string-repeat 5 "ha") ==> "hahahahaha"
