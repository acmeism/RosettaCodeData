/*REXX program finds and displays various kinds of  sexy and unsexy  primes less than N.*/
parse arg N endU end2 end3 end4 end5 .           /*obtain optional argument from the CL.*/
if    N==''  |    N==","  then    N= 1000035 - 1 /*Not specified?  Then use the default.*/
if endU==''  | endU==","  then endU=      10     /* "      "         "   "   "     "    */
if end2==''  | end2==","  then end2=       5     /* "      "         "   "   "     "    */
if end3==''  | end3==","  then end3=       5     /* "      "         "   "   "     "    */
if end4==''  | end4==","  then end4=       5     /* "      "         "   "   "     "    */
if end5==''  | end5==","  then end4=       5     /* "      "         "   "   "     "    */
call genSq                                       /*gen some squares for the DO k=7 UNTIL*/
call genPx                                       /* " prime (@.) & sexy prime (X.) array*/
call genXU                                       /*gen lists, types of sexy Ps, unsexy P*/
call getXs                                       /*gen lists, last # of types of sexy Ps*/
 @sexy= ' sexy prime'                            /*a handy literal for some of the SAYs.*/
 w2= words( translate(x2,, '~') ); y2= words(x2) /*count #primes in the sexy pairs.     */
 w3= words( translate(x3,, '~') ); y3= words(x3) /*  "   "   "    "  "    "  triplets.  */
 w4= words( translate(x4,, '~') ); y4= words(x4) /*  "   "   "    "  "    "  quadruplets*/
 w5= words( translate(x5,, '~') ); y5= words(x5) /*  "   "   "    "  "    "  quintuplets*/
say 'There are ' commas(w2%2) @sexy "pairs less than "             Nc
say 'The last '  commas(end2) @sexy "pairs are:";        say subword(x2, max(1,y2-end2+1))
say
say 'There are ' commas(w3%3) @sexy "triplets less than "          Nc
say 'The last '  commas(end3) @sexy "triplets are:";     say subword(x3, max(1,y3-end3+1))
say
say 'There are ' commas(w4%4) @sexy "quadruplets less than "       Nc
say 'The last '  commas(end4) @sexy "quadruplets are:";  say subword(x4, max(1,y4-end4+1))
say
say 'There is  ' commas(w5%5) @sexy "quintuplet less than "        Nc
say 'The last '  commas(end4) @sexy "quintuplet are:";   say subword(x5, max(1,y5-end4+1))
say
say 'There are ' commas(s1)         "   sexy primes less than "    Nc
say 'There are ' commas(u1)         " unsexy primes less than "    Nc
say 'The last '  commas(endU)       " unsexy primes are: "   subword(u,  max(1,u1-endU+1))
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;    n= _'.9';     #= 123456789;       b= verify(n, #, "M")
        e= verify(n, #'0', , verify(n, #"0.", 'M') ) - 4
           do j=e  to b  by -3;    _= insert(',', _, j);     end  /*j*/;          return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
genSQ: do i=17  by 2  until i**2 > N+7; s.i= i**2; end; return /*S used for square roots*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
genPx: @.=;              #= 0;          !.= 0.          /*P array; P count; sexy P array*/
       if N>1  then do;  #= 1;   @.1= 2;  !.2= 1;   end /*count of primes found (so far)*/
       x.=!.;                        LPs=3 5 7 11 13 17 /*sexy prime array;  low P list.*/
         do j=3  by 2  to  N+6                          /*start in the cellar & work up.*/
         if j<19  then if wordpos(j, LPs)==0  then iterate
                                              else do; #= #+1;  @.#= j;  !.j= 1;  b= j - 6
                                                       if !.b  then x.b= 1;        iterate
                                                   end
         if j// 3 ==0  then iterate                /* ··· and eliminate multiples of  3.*/
         parse var  j  ''  -1  _                   /* get the rightmost digit of  J.    */
         if     _ ==5  then iterate                /* ··· and eliminate multiples of  5.*/
         if j// 7 ==0  then iterate                /* ···  "      "         "      "  7.*/
         if j//11 ==0  then iterate                /* ···  "      "         "      " 11.*/
         if j//13 ==0  then iterate                /* ···  "      "         "      " 13.*/
                    do k=7  until s._ > j;  _= @.k /*÷ by primes starting at 7th prime. */
                    if j // _ == 0  then iterate j /*get the remainder of  j÷@.k    ___ */
                    end   /*k*/                    /*divide up through & including √ J  */
         if j<=N  then do;  #= #+1;  @.#= j;  end  /*bump P counter;  assign prime to @.*/
         !.j= 1                                    /*define  Jth  number as being prime.*/
              b= j - 6                             /*B: lower part of a sexy prime pair?*/
         if !.b then do; x.b=1; if j<=N then x.j=1; end /*assign (both parts ?) sexy Ps.*/
         end   /*j*/;       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genXU: u= 2;         Nc=commas(N+1);  s=           /*1st unsexy prime; add commas to N+1*/
       say 'There are ' commas(#)    " primes less than "          Nc;           say
          do k=2  for #-1; p= @.k; if x.p  then s=s p   /*if  sexy prime, add it to list*/
                                           else u= u p  /* " unsexy  "     "   "  "   " */
          end   /*k*/                                   /* [↑]  traispe through odd Ps. */
       s1= words(s);  u1= words(u);   return       /*# of sexy primes;  # unsexy primes.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
getXs: x2=;  do k=2  for #-1;  p=@.k;   if \x.p  then iterate  /*build sexy prime list. */
                               b=p- 6;  if \x.b  then iterate; x2=x2 b'~'p
             end   /*k*/
       x3=;  do k=2  for #-1;  p=@.k;   if \x.p  then iterate  /*build sexy P triplets. */
                               b=p- 6;  if \x.b  then iterate
                               t=p-12;  if \x.t  then iterate; x3=x3 t'~' || b"~"p
             end   /*k*/
       x4=;  do k=2  for #-1;  p=@.k;   if \x.p  then iterate  /*build sexy P quads.    */
                               b=p- 6;  if \x.b  then iterate
                               t=p-12;  if \x.t  then iterate
                               q=p-18;  if \x.q  then iterate; x4=x4 q'~'t"~" || b'~'p
             end   /*k*/
       x5=;  do k=2  for #-1;  p=@.k;   if \x.p  then iterate  /*build sexy P quints.   */
                               b=p- 6;  if \x.b  then iterate
                               t=p-12;  if \x.t  then iterate
                               q=p-18;  if \x.q  then iterate
                               v=p-24;  if \x.v  then iterate; x5=x5 v'~'q"~"t'~' || b"~"p
             end   /*k*/;    return
