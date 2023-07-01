(define p (open-output-file "/dev/lp0"))
(when p
   (print-to p "Hello world!")
   (close-port p))
