(define (timestamp) (syscall 201 "%c"))

(define (on-accept name fd)
(lambda ()
   (print "# " (timestamp) "> we got new visitor: " name)

   (let*((ss1 ms1 (clock)))
      (let loop ((str #null) (stream (force (port->bytestream fd))))
         (cond
            ((null? stream)
               #false)
            ((function? stream)
               (let ((message (list->string (reverse str))))
                  (print "# " (timestamp) "> client " name " wrote " message)
                  (print-to fd message))
               (loop #null (force stream)))
            (else
               (loop (cons (car stream) str) (cdr stream)))))
      (syscall 3 fd)
      (let*((ss2 ms2 (clock)))
         (print "# " (timestamp) "> visitor leave us. It takes "  (+ (* (- ss2 ss1) 1000) (- ms2 ms1)) "ms.")))))

(define (run port)
(let ((socket (syscall 41)))
   ; bind
   (let loop ((port port))
      (if (not (syscall 49 socket port)) ; bind
         (loop (+ port 2))
         (print "Server binded to " port)))
   ; listen
   (if (not (syscall 50 socket)) ; listen
      (shutdown (print "Can't listen")))

   ; accept
   (let loop ()
      (if (syscall 23 socket) ; select
         (let ((fd (syscall 43 socket))) ; accept
            (fork (on-accept (syscall 51 fd) fd))))
      (sleep 0)
      (loop))))

(run 12321)
