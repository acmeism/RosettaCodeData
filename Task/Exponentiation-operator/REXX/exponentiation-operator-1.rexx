/*REXX program  computes and displays  various   (integer)   exponentiations.           */
                                                 say center('digits='digits(), 79, "─")
say 'iPow(17, 65)  is:'
say  iPow(17, 65)
say

say 'iPow(0, -3)  is:'
say  iPow(0, -3)
say

say 'iPow(8, 0)  is:'
say  iPow(8, 0)
say

numeric digits 12;                               say center('digits='digits(), 79, "─")
say 'iPow(2, -10)  is:'
say  iPow(2, -10)
say

numeric digits 30;                               say center('digits='digits(), 79, "─")
say 'iPow(-3.1415926535897932384626433, 3)  is:'
say  iPow(-3.1415926535897932384626433, 3)
say

numeric digits 60;                               say center('digits='digits(), 79, "─")
say 'iPow(5, 70)  is:'
say  iPow(5, 70)
say

numeric digits 100;                              say center('digits='digits(), 79, "─")
say 'iPow(17, 65)  is:'
say  iPow(17, 65)
say

numeric digits 1000;                             say center('digits='digits(), 79, "─")
say 'iPow(2, 1000)  is:'
say  iPow(2, 1000)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
errMsg: say;     say '***error***';     say;     say arg(1);     say;     say;     exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
iPow:   procedure;  parse arg x 1 _,p;           #args= arg()  /*_:   is a copy of  X.  */
        if #args<2            then call errMsg  "not enough arguments specified"
        if #args>2            then call errMsg  "too many arguments specified"
        if \datatype(x, 'N')  then call errMsg  "1st arg isn't numeric:"         x
        if \datatype(p, 'W')  then call errMsg  "2nd arg isn't an integer:"      p
        if p=0                then return 1                    /*handle powers of zero. */
        if x=0  |  x=1        then return x                    /*handle special cases.  */
               do abs(p) - 1;      _= _ * x;   end             /*perform exponentiation */
        if p<0                then _= 1 / _                    /*process its reciprocal.*/
        return _
