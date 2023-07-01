(load "@lib/led.l" "@lib/term.l")

(fkey *XtF1
   (prinl "Initialized value to " (setq *Number 1)) )

(fkey *XtUp
   (prinl "Incremented to " (inc '*Number)) )

(fkey *XtDown
   (prinl "Decremented to " (dec '*Number)) )

(fkey *XtHome
   (prinl "Current value is " *Number) )
