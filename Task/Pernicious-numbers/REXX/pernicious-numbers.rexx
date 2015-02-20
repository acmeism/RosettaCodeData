/*REXX program displays a number of pernicious numbers and also a range.*/
numeric digits 30                      /*be able to handle large numbers*/
parse arg N L H .                      /*get optional arguments: N, L, H*/
if N=='' | N==','  then N=25           /*N given?  Then use the default.*/
if L=='' | L==','  then L=888888877    /*L   "  ?    "   "   "     "    */
if H=='' | H==','  then H=888888888    /*H   "  ?    "   "   "     "    */
say 'The 1st '  N  " pernicious numbers are:"    /*display a nice title.*/
say pernicious(1,,N)                   /*get all pernicious # from 1──►N*/
say                                    /*display a blank line for a sep.*/
say 'Pernicious numbers between '  L  " and "  H  ' (inclusive) are:'
say pernicious(L,H)                    /*get all pernicious # from L──►H*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────D2B subroutine──────────────────────*/
d2b: return word(strip(x2b(d2x(arg(1))),'L',0) 0,1)  /*convert dec──►bin*/
/*──────────────────────────────────PERNICIOUS subroutine───────────────*/
pernicious: procedure; parse arg bot,top,m /*get the bot & top #s, limit*/
_ = 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
!.=0;  do k=1 until p=''; p=word(_,k); !.p=1; end  /*gen low prime array*/
if m==''    then   m=999999999         /*assume an "infinite" limit.    */
if top==''  then top=999999999         /*assume an "infinite" top limit.*/
#=0                                    /*number of pernicious #s so far.*/
$=;  do j=bot  to top  until #==m      /*gen pernicious until satisfied.*/
     pc=popCount(j)                    /*obtain population count for  J.*/
     if \!.pc  then iterate            /*if popCount ¬ in !.prime, skip.*/
     $=$ j                             /*append a pernicious #  to list.*/
     #=#+1                             /*bump the pernicious #  count.  */
     end   /*j*/                       /* [↑]  append popCount to a list*/
return substr($,2)                     /*return results, sans 1st blank.*/
/*──────────────────────────────────POPCOUNT subroutine─────────────────*/
popCount: procedure;_=d2b(abs(arg(1))) /*convert the # passed to binary.*/
return length(_)-length(space(translate(_,,1),0))  /*count the one bits.*/
