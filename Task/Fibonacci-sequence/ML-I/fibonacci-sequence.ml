MCSKIP "WITH" NL
"" Fibonacci - recursive
MCSKIP MT,<>
MCINS %.
MCDEF FIB WITHS ()
AS <MCSET T1=%A1.
MCGO L1 UNLESS 2 GR T1
%T1.<>MCGO L0
%L1.%FIB(%T1.-1)+FIB(%T1.-2).>
fib(0) is FIB(0)
fib(1) is FIB(1)
fib(2) is FIB(2)
fib(3) is FIB(3)
fib(4) is FIB(4)
fib(5) is FIB(5)
