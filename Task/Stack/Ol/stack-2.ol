(fork-server 'stack (lambda ()
   (let this ((me '()))
      (let*((envelope (wait-mail))
            (sender msg envelope))
         (case msg
            (['empty]
               (mail sender (null? me))
               (this me))
            (['push value]
               (this (cons value me)))
            (['pop]
               (cond
                  ((null? me)
                     (mail sender #false)
                     (this me))
                  (else
                     (mail sender (car me))
                     (this (cdr me))))))))))
(define (push value)
   (mail 'stack ['push value]))
(define (pop)
   (interact 'stack ['pop]))
(define (empty)
   (interact 'stack ['empty]))

(for-each (lambda (n)
      (print "pushing " n)
      (push n))
   (iota 5 1)) ; '(1 2 3 4 5)

(let loop ()
   (print "is stack empty: " (empty))
   (unless (empty)
      (begin
         (print "popping value, got " (pop))
         (loop))))
(print "done.")
