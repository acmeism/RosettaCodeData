(define (isatty? fd) (syscall 16 fd 19))
(print (if (isatty? stdout)
   "stdout is a tty."
   "stdout is not a tty."))
