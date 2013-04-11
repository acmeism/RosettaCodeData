MCSKIP "WITH" NL
"" Ackermann function
"" Will overflow when it reaches implementation-defined signed integer limit
MCSKIP MT,<>
MCINS %.
MCDEF ACK WITHS ( , )
AS <MCSET T1=%A1.
MCSET T2=%A2.
MCGO L1 UNLESS T1 EN 0
%%T2.+1.MCGO L0
%L1.MCGO L2 UNLESS T2 EN 0
ACK(%%T1.-1.,1)MCGO L0
%L2.ACK(%%T1.-1.,ACK(%T1.,%%T2.-1.))>
"" Macro ACK now defined, so try it out
a(0,0) => ACK(0,0)
a(0,1) => ACK(0,1)
a(0,2) => ACK(0,2)
a(0,3) => ACK(0,3)
a(0,4) => ACK(0,4)
a(0,5) => ACK(0,5)
a(1,0) => ACK(1,0)
a(1,1) => ACK(1,1)
a(1,2) => ACK(1,2)
a(1,3) => ACK(1,3)
a(1,4) => ACK(1,4)
a(2,0) => ACK(2,0)
a(2,1) => ACK(2,1)
a(2,2) => ACK(2,2)
a(2,3) => ACK(2,3)
a(3,0) => ACK(3,0)
a(3,1) => ACK(3,1)
a(3,2) => ACK(3,2)
a(4,0) => ACK(4,0)
