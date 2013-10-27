/*REXX program generates  unbiased random numbers  and displays results.*/
parse arg samples seed .               /*allow specification of options.*/
if samples=='' | samples==','  then samples=1000    /*SAMPLES specified?*/
if seed\==''  then call random ,,seed  /*if specified, use it for RANDOM*/
w=14                                   /*width of most columnar output  */
dash='─'                               /*filler character for column hdr*/
say ct('N',3)  ct('biased')    ct('biased'),                 /*show the */
               ct('unbiased')  ct('unbiased')  ct('samples') /*6col hdr.*/
dash=
       do N=3  to 6;     b=0;   u=0;                   do j=1 for  samples
                                                       b=b + randN(N)
                                                       u=u + unbiased()
                                                       end   /*j*/
       say ct(N,3) ct(b) pc(b) ct(u) pc(u) ct(samples)
       end     /*N*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────one─line subroutines───────────────*/
ct:           return center(arg(1),  word(arg(2) w,1),   right(dash,1))
pc:           return ct(format(arg(1)/samples*100, , 2)'%')
randN:        parse arg z;          return random(1, z)==z
unbiased:     do  until  x\==randN(N);   x=randN(N);   end;       return x
