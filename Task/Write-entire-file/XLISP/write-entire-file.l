(define n (open-output-file "example.txt"))
(write "(Over)write a file so that it contains a string." n)
(close-output-port n)
