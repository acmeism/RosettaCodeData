/*REXX pgm sorts an array of integers (can be negative) using the  count─sort algorithm.*/
$= '1 3 6 2 7 13 20 12 21 11 22 10 23 9 24 8 25 43 62 42 63 41 18 42 17 43 16 44 15 45 14 46 79 113 78 114 77 39 78 38'
#= words($);          w= length(#);     !.= 0    /* [↑]  a list of some Recaman numbers.*/
m= 1;                 LO= word($, #);   HI= LO   /*M: max width of any integer in $ list*/
      do j=1  for #;  z= word($, j)+0;  @.j= z;  m= max(m, length(z) ) /*get from $ list*/
      !.z= !.z + 1;   LO= min(LO, z);   HI= max(HI, z)                 /*find LO and HI.*/
      end   /*j*/
                                                 /*W:  max index width for the @. array.*/
call show 'before sort: ';   say copies('▓', 55) /*show the   before   array elements.  */
call countSort   #                               /*sort a number of entries of @. array.*/
call show ' after sort: '                        /*show the    after   array elements.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countSort: parse arg N;  x= 1;    do k=LO  to  HI;   do x=x  for !.k;  @.x= k;  end  /*x*/
                                  end   /*k*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: do s=1  for #;  say right("element",20) right(s,w) arg(1) right(@.s,m); end;  return
