/*REXX program finds the  persistence and multiplicative  digital root  of some numbers.*/
numeric digits 2000                              /*increase the number of decimal digits*/
parse arg target x                               /*obtain optional arguments from the CL*/
if \datatype(target, 'W')  then target=25        /*Not specified?  Then use the default.*/
if x='' | x=","  then x=123321 7739 893 899998   /* "      "         "   "   "      "   */
say center('number',8)  ' persistence   multiplicative digital root'
say copies('─'     ,8)  ' ───────────   ───────────────────────────'
                                                 /* [↑]  the title  and  the separator. */
     do j=1  for words(x);  n=abs( word(x, j) )  /*process each number in the list.     */
     parse value  MDR(n)   with   mp mdr         /*obtain the persistence and the MDR.  */
     say right(n,8) center(mp,13) center(mdr,30) /*display the number, persistence, MDR.*/
     end   /*j*/                                 /* [↑] show MP and MDR for each number.*/
say                                              /* [↓] show a blank and the title line.*/
say 'MDR       first '  target  " numbers that have a matching MDR"
say '═══  ' copies("═",(target+(target+1)**2)%2) /*display a separator line (for title).*/

    do k=0  for 9;              hits=0           /*show numbers that have an MDR of  K. */
    _=
    if k==7  then _=@7                           /*handle the special case of  seven.   */
             else do m=k  until hits==target     /*find target numbers with an MDR of K.*/
                  parse var  m  ''  -1  ?        /*obtain the right─most digit of  M.   */
                  if k\==0  then if ?==0           then iterate
                  if k==5   then if ?//2==0        then iterate
                  if k==1   then m=copies(1, hits+1)
                            else if MDR(m, 1)\==k  then iterate
                  hits=hits+1                               /*got a hit, add to the list*/
                  _=space(_ m)                              /*elide superfluous blanks. */
                  if k==3  then do;      o=strip(m, 'T', 1) /*strip trailing ones from M*/
                                if o==3  then m=copies(1, length(m))3   /*make a new  M.*/
                                         else do;   t=pos(3, m) - 1     /*position of 3 */
                                              m=overlay(3, translate(m, 1, 3), t)
                                              end     /* [↑] shift the "3" 1 place left.*/
                                m=m - 1               /*adjust for  DO  index increment.*/
                                end                   /* [↑]  a shortcut to adj DO index*/
                  end   /*m*/                         /* [↑]  built a list of MDRs = K  */

    say " "k':    ['_"]"                         /*display the  K  (MDR)  and the list. */
    if k==3  then @7=translate(_, 7, k)          /*save for later, a special  "7"  case.*/
    end   /*k*/                                  /* [↑]  done with the  K  MDR list.    */

@.=                                              /* [↓]  handle MDR of  "9"  special.   */
_=translate(@7, 9, 7)                            /*translate string for MDR  of nine.   */
@9=translate(_, , ',')                           /*remove trailing commas from numbers. */
@3=                                              /*assign null string before building.  */

   do j=1  for words(@9)                         /*process each number for  MDR 9  case.*/
   _=space( translate( word(@9, j), , 9),  0)    /*elide all  "9"s   using   SPACE(x,0).*/
   L=length(_) + 1                               /*use a "fudged" length of the number. */
   new=                                          /*these are the new numbers  (so far). */

        do k=0 for L;       q=insert(3, _, k)    /*insert the  1st  "3"  into the number*/
          do i=k  to L;     z=insert(3, q, i)    /*   "    "   2nd  "3"    "   "     "  */
          if @.z\==''  then iterate              /*if already define, ignore the number.*/
          @.z=z;            new=z new            /*define it,  and then add to the list.*/
          end   /*i*/                            /* [↑]  end of  2nd  insertion of  "3".*/
        end     /*k*/                            /* [↑]   "  "   1st      "      "   "  */

   @3=space(@3 new)                              /*remove blanks,  then add to the list.*/
   end          /*j*/                            /* [↑]  end of insertion of the  "3"s. */

a1=@9;  a2=@3                                    /*define some strings for the merge.   */
@=                                               /* [↓]  merge two lists,  3s  and  9s. */
      do  while  a1\==''  &  a2\==''             /*process while the lists aren't empty.*/
      x=word(a1, 1);   y=word(a2, 1)             /*obtain the 1st word in A1 & A2 lists.*/
      if x=='' | y=='' then leave                /*are   X   or   Y   empty?            */
      if x<y  then do;   @=@ x;   a1=delword(a1, 1, 1);   end   /*add  X  to the @ list.*/
              else do;   @=@ y;   a2=delword(a2, 1, 1);   end   /* "   Y   "  "  "   "  */
      end   /*while*/                            /* [↑]  only process just enough nums. */

@=subword(@, 1, target)                          /*elide the last trailing comma in list*/
say " "9':     ['@"]"                            /*display the  "9" (MDR)  and the list.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
MDR: procedure; parse arg y,s;        y=abs(y)   /*get the number and determine the MDR.*/
                   do p=1      until  y<10;    parse var  y  r  2
                       do k=2  to length(y);   r=r * substr(y, k, 1)
                       end   /*k*/
                   y=r
                   end       /*p*/               /* [↑]  wash, rinse, and repeat ···    */
                if s==1  then return r           /*return multiplicative digital root.  */
                return p r                       /*return the persistence and the  MDR. */
