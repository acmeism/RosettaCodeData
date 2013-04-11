/*REXX program sorts an array using the   comb-sort   method.           */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show the before array elements.*/
call combSort highItem                 /*invoke the comb sort.          */
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COMBSORT subroutine─────────────────*/
combSort: procedure expose @.;  parse arg n
s=n-1                                  /*S = spread between COMBs.      */

  do  until s<=1 & done
  s=trunc(s*.8)                        /*  ÷   is slow,   *  is better. */
  done=1
           do j=1  until j+s>=n
           jps=j+s
           if @.j>@.jps  then do; _=@.j; @.j=@.jps; @.jps=_; done=0;  end
           end   /*j*/
  end            /*until*/

return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:  @.=                             /*assign the default value.      */
@.1 ='--- polygon    sides'
@.2 ='============== ====='
@.3 ='triangle         3'
@.4 ='quadrilateral    4'
@.5 ='pentagon         5'
@.6 ='hexagon          6'
@.7 ='heptagon         7'
@.8 ='octagon          8'
@.9 ='nonagon          9'
@.10='decagon         10'
@.11='dodecagon       12'
  do highItem=1 while @.highItem\==''  /*find how many entries in array.*/
  end
highItem=highItem-1                    /*adjust highItem slightly.      */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*the maximum width of any line. */
                               do j=1  for highItem
                               say 'element' right(j,widthH) arg(1)":" @.j
                               end
say copies('─',79)                     /*show a nice separator line.    */
return
