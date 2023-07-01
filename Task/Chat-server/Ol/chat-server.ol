(define (timestamp) (syscall 201 "%c"))

(fork-server 'chat-room (lambda ()
(let this ((visitors #empty))
(let* ((envelope (wait-mail))
       (sender msg envelope))
   (case msg
      (['join who name]
         (let ((visitors (put visitors who name)))
            (for-each (lambda (who)
                  (print-to (car who) name " joined to as"))
               (ff->alist visitors))
            (this visitors)))
      (['talk message]
         (for-each (lambda (who)
               (print-to (car who) (cdr who) ": " message))
            (ff->alist visitors))
         (this visitors))
      (['part who]
         (for-each (lambda (who)
               (print-to (car who) (visitors (car who) "unknown") " leaved"))
            (ff->alist visitors))
         (let ((visitors (del visitors who)))
            (this visitors))))))))


(define (on-accept name fd)
(lambda ()
   (print "# " (timestamp) "> we got new visitor: " name)
   (mail 'chat-room ['join fd name])

   (let*((ss1 ms1 (clock)))
      (let loop ((str #null) (stream (force (port->bytestream fd))))
         (cond
            ((null? stream)
               #false)
            ((function? stream)
               (mail 'chat-room ['talk (list->string (reverse str))])
               (loop #null (force stream)))
            (else
               (loop (cons (car stream) str) (cdr stream)))))
      (syscall 3 fd)
      (let*((ss2 ms2 (clock)))
         (print "# " (timestamp) "> visitor leave us. It takes "  (+ (* (- ss2 ss1) 1000) (- ms2 ms1)) "ms.")))
   (mail 'chat-room ['part fd])
   ))

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
            ;(print "\n# " (timestamp) ": new request from " (syscall 51 fd))
            (fork (on-accept (syscall 51 fd) fd))))
      (sleep 0)
      (loop))))

(run 8080)
