/*REXX program reorders a set of random colored balls into a correct order, which is the*/
/*────────────────────────────────── order of colors on the Dutch flag:  red white blue.*/
parse arg N colors                               /*obtain optional arguments from the CL*/
if N='' |  N=","  then N=15                      /*Not specified?  Then use the default.*/
if colors=''  then colors= 'red white blue'      /* "      "         "   "   "      "   */
#=words(colors)                                  /*count the number of colors specified.*/
@=word(colors, #)    word(colors, 1)             /*ensure balls aren't already in order.*/

    do g=3  to N                                 /*generate a random # of colored balls.*/
    @=@  word( colors, random(1, #) )            /*append a random color to the  @ list.*/
    end   /*g*/

say 'number of colored balls generated = '   N       ;  say
say center(' original ball order ', length(@), "─")
say @                                                ;  say
$=;                          do j=1  for #;
                             _=word(colors, j);      $=$  copies(_' ',   countWords(_, @))
                             end   /*j*/
say
say center(' sorted  ball order ', length(@), "─")
say space($)
say
    do k=2  to  N                                /*verify the balls are in correct order*/
    if wordpos(word($,k), colors) >= wordpos(word($,k-1), colors)  then iterate
    say "The list of sorted balls isn't in proper order!";         exit 13
    end   /*k*/
say
say 'The sorted colored ball list has been confirmed as being sorted correctly.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countWords:  procedure;   parse arg ?,hay;  s=1
                  do r=0  until _==0;  _=wordpos(?, hay, s);  s=_+1;  end /*r*/;  return r
