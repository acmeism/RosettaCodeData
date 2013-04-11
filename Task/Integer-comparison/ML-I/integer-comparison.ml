"" Integer comparison
"" assumes macros on input stream 1, terminal on stream 2
MCSKIP MT,<>
MCSKIP SL WITH ~
MCINS %.
MCDEF SL SPACES NL AS <MCSET T1=%A1.
MCSET T2=%A2.
MCGO L1 UNLESS T1 EN T2
%A1. is equal to %A2.
%L1.MCGO L2 UNLESS %A1. GR %A2.
%A1. is greater than %A2.
%L2.MCGO L3 IF %A1. GE %A2.
%A1. is less than %A2.
%L3.
MCSET S10=0
>
MCSET S1=1
~MCSET S10=2
