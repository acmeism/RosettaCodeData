(import (owl parse))

(coroutine 'reader (lambda ()
   ; lazy line-by-line file reader
   (define (not-a-newline x) (not (eq? x #\newline)))
   (define parser (let-parse*
                        ((line (greedy* (byte-if not-a-newline)))
                         (newline (imm #\newline)))
                     (bytes->string line)))
   (define file (file->bytestream "input.txt"))

   (let loop ((in (try-parse parser file #false)))
      (cond
         ((not in) ; file is ended
            (define envelope (wait-mail)) ; wait for a request
            (mail (ref envelope 1) #eof)) ; send an end-of-file to caller
         ((pair? in) ; new line is read
            (define envelope (wait-mail)) ; wait for a request
            (mail (ref envelope 1) (car in)) ; send a line to caller
            (loop (try-parse parser (cdr in) #false)))
         (else ; just a lazy read, let's repeat
            (loop (force in)))))

   (print "total lines read: " (await (mail 'writer #t)))
))

(coroutine 'writer (lambda ()
   (let loop ((n 0))
      (define line (await (mail 'reader #t)))

      (if (eof? line)
      then
         (define envelope (wait-mail)) ; wait for a request
         (mail (ref envelope 1) n) ; send a lines count to caller
      else
         (print "read line: " line)
         (loop (+ n 1))))))
