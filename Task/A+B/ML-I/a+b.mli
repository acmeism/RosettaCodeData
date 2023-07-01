MCSKIP "WITH" NL
"" A+B
"" assumes macros on input stream 1, terminal on stream 2
MCSKIP MT,<>
MCINS %.
MCDEF SL SPACES NL AS <MCSET T1=%A1.
MCSET T2=%A2.
%T1+T2.
MCSET S10=0
>
MCSKIP SL WITH *
MCSET S1=1
*MCSET S10=2
