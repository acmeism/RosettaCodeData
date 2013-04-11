; memory efficient
(define (string-repeat n string)
  (with-output-to-string
   (λ ()
     (for ([_ (in-range n)])
       (display string)))))
(string-repeat 5 "ha") ==> "hahahahaha"
