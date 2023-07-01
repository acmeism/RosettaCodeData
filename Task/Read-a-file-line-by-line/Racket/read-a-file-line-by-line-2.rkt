(define in (open-input-file file-name))
(for ([line (in-lines in)])
     (displayln line))
(close-input-port in)
