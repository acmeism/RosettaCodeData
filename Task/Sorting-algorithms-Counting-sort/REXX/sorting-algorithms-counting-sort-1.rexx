/*REXX pgm sorts an array of integers (can be negative) using the  count─sort algorithm.*/
$=1 3 6 2 7 13 20 12 21 11 22 10 23 9 24 8 25 43 62 42 63 41 18 42 17 43 16 44 15 45 14 46 79 113 78 114 77 39 78 38
#=words($);             w=length(#)              /* [↑]  a list of some Recaman numbers.*/
m=0;                    _.=0                     /*M:  max width of any number in  @.   */
     do i=1  for #;     z=word($, i);   @.i=z;   m=max(m, length(z)) /*get from $ list. */
     if i==1  then do;  LO=z;           HI=z;             end        /*assume z: LO & HI*/
     _.z= _.z + 1;      LO=min(LO, z);  HI=max(HI, z)                /*find the LO & HI.*/
     end   /*i*/
                                                 /*W:  max index width for the  @. array*/
call show 'before sort: '                        /*show the   before   array elements.  */
           say  copies('▒', 55)                  /*show a separator line (before/after).*/
call countSort  #                                /*sort a number of entries of @. array.*/
call show ' after sort: '                        /*show the    after   array elements.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countSort: parse arg N;                              x=1
                        do k=LO  to  HI;          do x=x  for _.k;    @.x=k;    end  /*x*/
                        end   /*k*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: do s=1  for #;  say right("element",20) right(s,w) arg(1) right(@.s,m); end;  return
