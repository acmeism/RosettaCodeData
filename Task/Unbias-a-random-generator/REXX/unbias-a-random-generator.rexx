/*REXX program generates  unbiased random numbers  and displays the results to terminal.*/
parse arg # R seed .                             /*obtain optional arguments from the CL*/
if #==''  |  #==","     then #=1000              /*#:  the number of SAMPLES to be used.*/
if R==''  |  R==","     then R=6                 /*R:  the high number for the  range.  */
if datatype(seed, 'W')  then call random ,,seed  /*Specified?  Then use for RANDOM seed.*/
dash='─';    @b="biased";         @ub='un'@b     /*literals for the SAY column headers. */
say left('',5)   ctr("N",5)   ctr(@b)   ctr(@b'%')  ctr(@ub)  ctr(@ub"%")   ctr('samples')
dash=
       do N=3  to R;      b=0;                u=0
         do j=1  for #;   b=b + randN(N);     u=u + unbiased()
         end   /*j*/
       say  left('', 5)     ctr(N, 5)     ctr(b)    pct(b)    ctr(u)    pct(u)    ctr(#)
       end     /*N*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ctr:       return center( arg(1), word(arg(2) 12, 1), left(dash, 1)) /*show hdr│numbers.*/
pct:       return ctr( format(arg(1) / # * 100, , 2)'%' )            /*2 decimal digits.*/
randN:     parse arg z;            return random(1, z)==z            /*ret 1 if rand==Z.*/
unbiased:  do  until x\==randN(N); x=randN(N);  end;       return x  /* "  unbiased RAND*/
