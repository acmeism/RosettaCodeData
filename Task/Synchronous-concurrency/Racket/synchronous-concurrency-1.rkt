(define (reader)
  (for ([line (in-lines (open-input-file "input.txt"))])
    (thread-send printer-thread line))
  (thread-send printer-thread eof)
  (printf "Number of lines: ~a\n" (thread-receive)))

(define (printer)
  (thread-send reader-thread
               (for/sum ([line (in-producer thread-receive eof)])
                 (displayln line)
                 1)))

(define printer-thread (thread printer))
(define reader-thread  (thread reader))

(for-each thread-wait
          (list printer-thread reader-thread))
