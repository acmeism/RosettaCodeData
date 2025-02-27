; For R6RS Scheme i.e. Chez Scheme
(define file (open-input-file path))
(do ((line (get-line file) (get-line file))) ((eof-object? line))
        (display line)
        (newline))
