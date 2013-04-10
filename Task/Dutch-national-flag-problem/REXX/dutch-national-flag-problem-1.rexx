/*REXX pgm to reorder a set of random colored balls into a correct order*/
/*which is the order of colors on the Dutch flag:   red,  white,  blue. */

parse arg N colors                     /*get user args from command line*/
if N=',' |  N=''  then N=15            /*use default number of balls.   */
if      N='' then N=15                 /*use default number of balls.   */
if colors='' then colors=space('red white blue')   /*use default colors.*/
Ncolors=words(colors)                  /*count the number of colors.    */
@=word(colors,Ncolors) word(colors,1)  /*ensure balls aren't in order.  */

                  do g=3 to N          /*generate a random # of balls.  */
                  @=@ word(colors,random(1,Ncolors))
                  end   /*g*/

say 'number of colored balls generated = ' N        ;  say
say 'original ball order:'
say @                                               ;  say
$=;                           do j=1 for Ncolors;   ;  _=word(colors,j)
                              $=$ copies(_' ',countWords(_,@))
                              end   /*j*/
say ' sorted  ball order:'
say space($);   say

    do k=2 to N                        /*ensure the balls are in order. */
    if wordpos(word($,k),colors)>=wordpos(word($,k-1),colors) then iterate
    say "The list of sorted balls isn't in proper order!";   exit 13
    end   /*k*/

say ' sorted  ball list has been confirmed as being sorted correctly.'
exit                                   /*stick a fork in it, we're done.*
/*──────────────────────────────────COUNTWORDS subroutine───────────────*/
countWords:  procedure;   parse arg ?,hay;  s=1
         do r=0 until _==0;  _=wordpos(?,hay,s);  s=_+1;  end;    return r
