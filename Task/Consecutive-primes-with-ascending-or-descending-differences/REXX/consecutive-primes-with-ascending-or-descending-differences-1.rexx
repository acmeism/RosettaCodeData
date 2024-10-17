/*REXX program finds the longest sequence of consecutive primes where the differences   */
/*──────────── between the primes are strictly ascending;  also for strictly descending.*/
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 1000000      /* "      "         "   "   "     "    */
if cols=='' | cols==","  then cols=      10      /* "      "         "   "   "     "    */
call genP                                        /*build array of semaphores for primes.*/
w= 10                                            /*width of a number in any column.     */
call fRun 1;  call show 1                        /*find runs with ascending prime diffs.*/
call fRun 0;  call show 0                        /*  "    "    " descending   "     "   */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
fRun: parse arg ?;    mxrun=0;     seq.=         /*max run length;  lists of prime runs.*/
                                                 /*search for consecutive primes  <  HI.*/
        do j=2  for #-2;   cp= @.j;   jn= j+1    /*CP: current prime;  JN:  next j      */
        diff= @.jn - cp                          /*get difference between last 2 primes.*/
        cnt= 1;                       run=       /*initialize the   CNT   and   RUN.    */
               do k= jn+1  to #-2;    km= k-1    /*look for more primes in this run.    */
               if ?  then if @.k-@.km<=diff  then leave  /*Diff. too small? Stop looking*/
                                             else nop
                     else if @.k-@.km>=diff  then leave  /*  "    "  large?   "     "   */
               run= run  @.k;         cnt= cnt+1 /*append a prime to the run; bump count*/
               diff= @.k - @.km                  /*calculate difference for next prime. */
               end   /*k*/
        if cnt<=mxrun  then iterate              /*This run too short? Then keep looking*/
        mxrun= max(mxrun, cnt)                   /*define a new maximum run (seq) length*/
        seq.mxrun= cp  @.jn  run                 /*full populate the sequence (RUN).    */
        end   /*j*/;                   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13; @.7=17; @.8=19    /*define low primes.*/
                           #=8;   sq.#= @.# ** 2 /*number of primes so far; prime sqiare*/
                                                 /* [↓]  generate more  primes  ≤  high.*/
        do j=@.#+2  by 2  to hi;  parse var j '' -1 _    /*find odd primes from here on.*/
        if     _==5  then iterate;  if j// 3==0  then iterate   /*J ÷  5?    J ÷ by  3? */
        if j// 7==0  then iterate;  if j//11==0  then iterate   /*" "  7?    " "  " 11? */
        if j//13==0  then iterate;  if j//17==0  then iterate   /*" " 13?    " " "  17? */
               do k=8  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;             @.#= j;    sq.#= j*j /*bump # of Ps; assign next P; P square*/
        end          /*j*/;            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg ?;  if ?  then AorD= 'ascending'     /*choose which literal for display.*/
                          else AorD= 'descending'    /*   "     "      "     "     "    */
      title= ' longest run of consecutive primes whose differences between primes are'  ,
                              'strictly'         AorD         "and  < "         commas(hi)
      say;    say;    say
      if cols>0  then say ' index │'center(title,   1 + cols*(w+1)     )
      if cols>0  then say '───────┼'center(""   ,   1 + cols*(w+1), '─')
      found= 0;                idx= 1            /*initialize # of consecutive primes.  */
      $=                                         /*a list of consecutive primes (so far)*/
         do o=1  for words(seq.mxrun)            /*show all consecutive primes in seq.  */
         c= commas( word(seq.mxrun, o) )         /*obtain the next prime in the sequence*/
         found= found + 1                        /*bump the number of consecutive primes*/
         if cols<=0            then iterate      /*build the list  (to be shown later)? */
         $= $  right(c, max(w, length(c) ) )     /*add a nice prime ──► list, allow big#*/
         if found//cols\==0    then iterate      /*have we populated a line of output?  */
         say center(idx, 7)'│'  substr($, 2)     /*display what we have so far  (cols). */
         idx= idx + cols;              $=        /*bump the  index  count for the output*/
         end   /*o*/
      if $\==''  then say center(idx, 7)"│"  substr($, 2)   /*maybe show residual output*/
      if cols>0  then say '───────┴'center(""   ,   1 + cols*(w+1), '─')
      say;            say commas(Cprimes)  ' was the'title;        return
