/*REXX pgm finds persistence and multiplicative digital root of some #'s*/
numeric digits 100                     /*increase the number of digits. */
parse arg x                            /*get some numbers from the C.L. */
if x=''  then x=123321 7739 893 899998 /*use defaults if none specified.*/
say center('number',8)  ' persistence   multiplicative digital root'
say copies('─'     ,8)  ' ───────────   ───────────────────────────'
                                       /* [↑]  title  and  separator.   */
     do j=1  for words(x); n=word(x,j) /*process each number in the list*/
     parse value mdr(n)  with  mp mdr  /*obtain the persistence and MDR.*/
     say right(n,8) center(mp,13) center(mdr,30)   /*display #, mp, mdr.*/
     end   /*j*/                       /* [↑] show MP and MDR for each #*/
say;                    target=5
say 'MDR        first '  target  " numbers that have a matching MDR"
say '═══   ═══════════════════════════════════════════════════'
     do k=0  for 10;  hits=0;  _=      /*show #'s that have an MDR of K.*/
       do m=k  until hits==target      /*find target #s with an MDR of K*/
       if word(mdr(m),2)\==k  then iterate  /*is the MDR what's wanted? */
       hits=hits+1;  _=space(_ m',')   /*yes, we got a hit, add to list.*/
       end   /*m*/                     /* [↑]  built a list of MDRs = k */
     say " "k':     ['strip(_,,',')"]" /*display the  K  (mdr) and list.*/
     end     /*k*/                     /* [↑]  done with the K mdr list.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MDR subroutine──────────────────────*/
mdr: procedure; parse arg y; y=abs(y)  /*get the number and find the MDR*/
   do p=1  until  y<10                 /*find multiplicative digRoot (Y)*/
   parse var y 1 r 2;  do k=2  to length(y);  r=r*substr(y,k,1); end;  y=r
   end   /*p*/                         /*wash, rinse, repeat ···        */
return p r                             /*return the persistence and MDR.*/
