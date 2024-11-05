include Settings

say version; say 'Moebius sequence'; say
parse arg LO HI grp .                            /*obtain optional arguments from the CL*/
numeric digits 100
if  LO=='' |  LO==","  then  LO=   0             /*Not specified?  Then use the default.*/
if  HI=='' |  HI==","  then  HI= 199             /* "      "         "   "   "     "    */
if grp=='' | grp==","  then grp=  20             /* "      "         "   "   "     "    */
                                                 /*                            ______   */
say Center(' The Moebius sequence from ' LO " --> " HI" ", Max(50, grp*3), '=')   /*title*/
dd=''                                            /*variable holds output grid of GRP #s.*/
    do j=LO  to  HI;  dd= dd Right( Moebius(j), 2) /*process some numbers from LO --> HI.*/
    if Words(dd)==grp then do;  say Substr(dd, 2); dd='' /*show grid if fully populated,*/
                           end                           /*  and nullify it for more #s.*/
    end   /*j*/                                  /*for small grids, using wordCnt is OK.*/
if dd\=='' then say Substr(dd, 2)                /*handle any residual numbers not shown*/
say Format(Time('e'),,3) 'seconds'
exit                                             /*stick a fork in it,  we're all done. */

Moebius:
/* Moebius sequence */
procedure expose fact. ufac.
arg x
/* Special value */
if x = 0 then
   return '*'
/* Using # of (unique) prime factors */
call Factors(x)
call Ufactors(x)
if fact.0 = ufac.0 then
   if IsEven(fact.factor.0) then
      return 1
   else
      return -1
else
   return 0

include Functions
include Numbers
include Sequences
include Abend
