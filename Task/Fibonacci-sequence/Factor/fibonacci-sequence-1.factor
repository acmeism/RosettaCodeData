! produce the nth fib
: fib ( n -- fib )     1 0 rot [ tuck + ]      times     drop ; inline

! produce a list of the first n fibs
: fibseq ( n -- fibs ) 1 0 rot [ [ + ] 2keep ] replicate 2nip ; inline
