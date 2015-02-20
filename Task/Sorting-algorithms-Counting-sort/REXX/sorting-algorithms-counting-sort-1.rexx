/*REXX program sorts an  array  using the   count-sort   algorithm.     */
call gen@                              /*generate the array elements.   */
call show@  'before sort'              /*show the before array elements.*/
call countSort  #                      /*sort N entries of the @. array.*/
call show@  ' after sort'              /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COUNTSORT subroutine────────────────*/
countSort:  procedure expose @.;    parse arg N;          h=@.1;       L=h

        do i=2  to N;   L=min(L,@.i);     h=max(h,@.i);   end   /*i*/

_.=0;   do j=1  for N;  x=@.j;            _.x=_.x+1;      end   /*j*/

x=1;    do k=L  to h;   if _.k\==0  then  do x=x  for _.k
                                          @.x=k
                                          end   /*x*/
        end   /*k*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: $=1 3 6 2 7 13 20 12 21 11 22 10 23 9 24 8 25 43 62 42 63 41 18 42 17 43 16 44 15 45 14 46 79 113 78 114 77 39 78 38
#=words($)
            do j=1  for #              /* [↓] assign 40 Recaman numbers.*/
            @.j=word($,j)              /*assign a Recaman # from a list.*/
            end   /*j*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:  do s=1  for #
        say left('',9)  "element"   right(s,length(#))   arg(1)': '    @.s
        end   /*s*/

say copies('─',50)                     /*show a pretty separator line.  */
return
