(define (isatty? fd) (syscall 16 fd 19))
(print (if (isatty? stdin)
   "Input comes from tty."
   "Input doesn't come from tty."))
