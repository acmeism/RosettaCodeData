/*REXX program demonstrates various ways REXX can convert and/or normalize some numbers.*/
digs=digits()   ;                                     say digs   /* 9,  the default.*/

a=.1.2...$      ;                                     say a      /* .1.2...$        */
a=+7            ;                                     say a      /* 7               */
a='+66'         ;                                     say a      /* +66             */
a='- 66.'       ;                                     say a      /* - 66.           */
a=- 66          ;                                     say a      /* -66             */
a=- 66.         ;                                     say a      /* -66             */
a=+ 66          ;                                     say a      /* 66              */
a=1             ;    b=2.000   ;    x=a+b      ;      say x      /* 3.000           */
a=1             ;    b=2.000   ;    x=(a+b)/1  ;      say x      /* 3               */
a=+2            ;    b=+3      ;    x=a+b      ;      say x      /* 5               */
a=+5            ;    b=+3e1    ;    x=a+b      ;      say x      /* 35              */
a=1e3           ;                                     say a      /* 1E3             */
a="1e+003"      ;                                     say a      /* 1e+003          */
a=1e+003        ;                                     say a      /* 1E+003          */
a=1e+003        ;    b=0       ;    x=a+b      ;      say x      /* 1000            */
a=12345678912   ;                                     say a      /* 123456789012    */
a=12345678912   ;    b=0       ;    x=a+b      ;      say x      /* 1.23456789E+10  */
