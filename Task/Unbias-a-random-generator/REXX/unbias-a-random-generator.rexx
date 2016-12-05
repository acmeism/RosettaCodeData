/*REXX program generates  unbiased random numbers  and displays the results to terminal.*/
parse arg # R seed .                             /*get optional parameters from the CL. */
if #==''  |  #==","     then #=1000              /*#   the number of SAMPLES to be used.*/
if R==''  |  R==","     then R=6                 /*R   the high number for the range.   */
if datatype(seed, 'W')  then call random ,,seed  /*Not specified?  Use for RANDOM seed. */
w=12;       pad=left('',5)                       /*width of columnar output; indentation*/
dash='─';   @b="biased";     @ub='un'@b          /*literals for the SAY column headers. */
say pad c('N',5)  c(@b)  c(@b'%')  c(@ub)  c(@ub"%")  c('samples')  /*six column header.*/
dash=
      do N=3  to R;    b=0;    u=0;                        do j=1  for #;   b=b+randN(N)
                                                                            u=u+unbiased()
                                                           end   /*j*/
      say pad  c(N,5)  c(b)  pct(b)  c(u)  pct(u)  c(#)
      end   /*N*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
c:          return center( arg(1), word(arg(2) w, 1), left(dash, 1) )
pct:        return c( format(arg(1) / # * 100, , 2)'%' )           /*two decimal digits.*/
randN:      parse arg z;                           return random(1, z)==z
unbiased:   do  until x\==randN(N);  x=randN(N);   end  /*until*/;                return x
