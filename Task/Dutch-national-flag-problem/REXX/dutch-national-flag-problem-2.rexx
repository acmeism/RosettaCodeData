/*REXX pgm to reorder a set of random colored balls into a correct order*/
/*which is the order of colors on the Dutch flag:   red,  white,  blue. */

parse arg N colors .                   /*get user args from command line*/
if N==',' |  N==''  then N=15          /*use default number of balls.   */
if colors=''       then colors='RWB'   /*default: R=red, W=white, B=blue*/
Ncolors=length(colors)                 /*count the number of colors.    */
@=right(colors,1)left(colors,1)        /*ensure balls aren't in order.  */

                  do g=3 to N          /*generate a random # of balls.  */
                  @=@ || substr(colors,random(1,Ncolors),1)
                  end   /*g*/

say 'number of colored balls generated = ' N       ;  say
say 'original ball order:'
say @                                              ;  say
$=;                           do j=1 for Ncolors;     _=substr(colors,j,1)
                              #=length(@)-length(space(translate(@,,_),0))
                              $=$||copies(_,#)
                              end   /*j*/
say ' sorted  ball order:'
say $;    say

    do k=2 to N                        /*ensure the balls are in order. */
    if pos(substr($,k,1),colors)>=pos(substr($,k-1,1),colors) then iterate
    say "The list of sorted balls isn't in proper order!";   exit 13
    end   /*k*/

say ' sorted  ball list has been confirmed as being sorted correctly.'
                                       /*stick a fork in it, we're done.*/
