MCSKIP "WITH" NL
"" Integer sequence
"" Will overflow when it reaches implementation-defined signed integer limit
MCSKIP MT,<>
MCINS %.
MCDEF DEMO WITHS NL AS <MCSET T1=1
%L1.%T1.
MCSET T1=T1+1
MCGO L1
>
DEMO
