MCSKIP "WITH" NL
"" 100 doors
MCINS %.
MCSKIP MT,<>
"" Doors represented by P1-P100, 0 is closed
MCPVAR 100
"" Set P variables to 0
MCDEF ZEROPS WITHS NL AS <MCSET T1=1
%L1.MCSET PT1=0
MCSET T1=T1+1
MCGO L1 UNLESS T1 EN 101
>
ZEROPS
"" Generate door state
MCDEF STATE WITHS () AS <MCSET T1=%A1.
MCGO L1 UNLESS T1 EN 0
closed<>MCGO L0
%L1.open>
"" Main macro - no arguments
"" T1 is pass number
"" T2 is door number
MCDEF DOORS WITHS NL
AS <MCSET T1=1
"" pass loop
%L1.MCGO L4 IF T1 GR 100
"" door loop
MCSET T2=T1
%L2.MCGO L3 IF T2 GR 100
MCSET PT2=1-PT2
MCSET T2=T2+T1
MCGO L2
%L3.MCSET T1=T1+1
MCGO L1
%L4."" now output the result
MCSET T1=1
%L5.door %T1. is STATE(%PT1.)
MCSET T1=T1+1
MCGO L5 UNLESS T1 GR 100
>
"" Do it
DOORS
