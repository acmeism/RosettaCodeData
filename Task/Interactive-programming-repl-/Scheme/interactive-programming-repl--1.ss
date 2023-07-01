> scheme
Scheme Microcode Version 14.9
MIT Scheme running under FreeBSD
Type `^C' (control-C) followed by `H' to obtain information about interrupts.
Scheme saved on Monday June 17, 2002 at 10:03:44 PM
  Release 7.7.1
  Microcode 14.9
  Runtime 15.1

1 ]=> (define (f string-1 string-2 separator)
        (string-append string-1 separator separator string-2))

;Value: f

1 ]=> (f "Rosetta" "Code" ":")

;Value 1: "Rosetta::Code"

1 ]=> ^D
End of input stream reached
Happy Happy Joy Joy.
>
