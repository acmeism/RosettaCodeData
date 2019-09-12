(define (reader out-ch result-ch)
  (for ([line (in-lines (open-input-file "input.txt"))])
    (channel-put out-ch line))
  (channel-put out-ch eof)
  (printf "Number of lines: ~a\n" (channel-get result-ch)))

(define (printer in-ch result-ch)
  (channel-put result-ch
               (for/sum ([line (in-producer channel-get eof in-ch)])
                 (displayln line)
                 1)))

(define lines-ch (make-channel))
(define result-ch (make-channel))
(define printer-thread (thread (lambda () (printer lines-ch result-ch))))
(define reader-thread  (thread (lambda () (reader lines-ch result-ch))))

(for-each thread-wait
          (list printer-thread reader-thread))
