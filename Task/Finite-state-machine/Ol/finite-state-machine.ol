(import (scheme read))

; finite state machine
(define (state-machine states initial-state)
   (let loop ((state initial-state))
      (let*((action ((states state) 'enter #f))
            (process-enter (if (function? action) (action)))
            (next-state (if (symbol? action) action
                        else
                           ((states state) (string->symbol (symbol->string (read))) state))))
         (loop next-state))))

; task states
(define states {
   'ready {
      'enter (lambda () (print "Write (d)eposit for deposit and (q)uit to exit."))

      'd 'waiting
      'deposit 'waiting
      'q 'exit
      'quit 'exit
   }

   'exit {
      'enter (lambda () (halt 1))
   }

   'waiting {
      'enter (lambda () (print "Write (s)elect for dispense or (r)efund for refund."))

      's 'dispense
      'select 'dispense
      'r 'refunding
      'refund 'refunding
   }

   'dispense {
      'enter (lambda () (print "Write (r)emove to finish action."))

      'r 'ready
      'remove 'ready
   }

   'refunding {
      'enter 'ready
   }
})

; run
(state-machine states 'ready)
