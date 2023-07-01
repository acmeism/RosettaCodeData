/*REXX program finds and displays  primes  with successive differences  (up to a limit).*/
parse arg H . 1 . difs                           /*allow the highest number be specified*/
if H=='' | H==","  then  H= 1000000              /*Not specified?  Then use the default.*/
if difs=''   then  difs= 2 1 2.2 2.4 4.2 6.4.2   /* "      "         "   "   "     "    */
call genP H

        do j=1  for words(difs)                             /*traipse through the lists.*/
        dif= translate( word(difs, j),,.);  dw= words(dif)  /*obtain true differences.  */
            do i=1  for dw;  dif.i= word(dif, i)            /*build an array of diffs.  */
            end   /*i*/                                     /* [↑]  for optimization.   */
        say center('primes with differences of:'  dif,  50, '─')        /*display title.*/
        p= 1;                        c= 0;        grp=      /*init. prime#,  count, grp.*/
             do a=1;  p= nextP(p+1);  if p==0  then leave   /*find the next  DIF  primes*/
             aa= p;   !.=                                   /*AA: nextP;  the group #'s.*/
             !.1= p                                         /*assign 1st prime in group.*/
                    do g=2  for dw                          /*get the rest of the group.*/
                    aa= nextP(aa+1); if aa==0  then leave a /*obtain the next prime.    */
                    !.g= aa;         _= g-1                 /*prepare to add difference.*/
                    if !._ + dif._\==!.g  then iterate a    /*determine if fits criteria*/
                    end   /*g*/
             c= c+1                                         /*bump count of # of groups.*/
             grp= !.1;       do b=2  for dw;  grp= grp !.b  /*build a list of primes.   */
                             end   /*b*/
             if c==1  then say '     first group: '   grp   /*display the first group.  */
             end   /*a*/
                                                            /* [↓]  test if group found.*/
        if grp==''   then say "         (none)"             /*display the  last group.  */
                     else say '      last group: '   grp    /*   "     "     "    "     */
                          say '           count: '   c      /*   "     "  group count.  */
        say
        end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
nextP:    do nxt=arg(1)  to H;  if @.nxt==.  then return nxt;  end /*nxt*/;     return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: procedure expose @.; parse arg N;  != 0;  @.=.;  @.1=      /*initialize the array.*/
          do e=4  by 2  for (N-1)%2;  @.e=;  end /*treat the even integers > 2  special.*/
                                                 /*all primes are indicated with a  "." */
        do j=1  by 2  for (N-1)%2                /*use odd integers up to  N  inclusive.*/
        if @.j==.  then do;  if !  then iterate  /*Prime?   Should skip the top part ?  */
                             jj= j * j           /*compute the square of  J.        ___ */
                             if jj>N  then != 1  /*indicate skip top part  if  j > √ N  */
                               do m=jj  to N  by j+j;  @.m=;  end       /*odd multiples.*/
                        end                      /* [↑]  strike odd multiples  ¬ prime. */
        end   /*j*/;               return
