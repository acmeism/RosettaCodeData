MCSKIP "WITH" NL
"" Align columns - assumes macros on input stream 1, data on stream 2
MCPVAR 102
"" Set P102 to alignment required:
""   1 = centre
""   2 = left
""   3 = right
MCSET P102 = 1
MCSKIP MT,<>
MCINS %.
MCSKIP SL WITH *
"" Assume no more than 100 columns - P101 used for max number of fields
"" Set P variables 1-101 to 0
MCDEF ZEROPS WITHS NL AS <MCSET T1=1
%L1.MCSET PT1=0
MCSET T1=T1+1
MCGO L1 UNLESS T1 EN 102
>
ZEROPS
"" First pass - macro to accumulate max columns, and max widths
MCDEF SL N1 OPT $ N1 OR $ WITHS NL OR SPACE WITHS NL OR NL ALL
AS <MCGO L3 UNLESS T1 GR P101
MCSET P101=T1
%L3.MCSET T2=1
%L1.MCGO L0 IF T2 GR T1
MCSET T3=MCLENG(%WBT2.)
MCGO L2 UNLESS T3 GR PT2
MCSET PT2=T3
%L2.MCSET T2=T2+1
MCGO L1
>
MCSET S1=1
*MCSET S10=2
*MCSET S1=0
MCSET S4=1
""MCNOTE Max field is %P101.
""MCDEF REP NL AS <MCSET T1=1
""%L1.%PT1. MCSET T1=T1+1
""MCGO L1 UNLESS T1 GR P101
"">
""REP
MCDEF SL N1 OPT $ N1 OR $ WITHS NL OR SPACE WITHS NL OR NL ALL
AS <MCSET T2=1
%L5.MCGO L6 IF T2 GR T1
MCGO LP102
%L1.MCSET T3=%%%PT2.-MCLENG(%WBT2.)./2.
MCGO L7 IF T3 EN 0
MCSUB(<                            >,1,T3)%L7.%WBT2.""
MCSUB(<                            >,1,PT2-T3-MCLENG(%WBT2.)+1)MCGO L4
%L2.MCSUB(%WBT2.<                              >,1,PT2)MCGO L4
%L3.MCSUB(<                              >%WBT2.,1-PT2,0)""
%L4. MCSET T2=T2+1
MCGO L5
%L6.
>
MCSET S1=1
*MCSET S10=102
