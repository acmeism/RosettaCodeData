/*REXX program "squeezes" all immediately repeated characters in a string (or strings). */
@.=                                              /*define a default for the  @.  array. */
#.1= ' '; @.1=
#.2= '-'; @.2= '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln '
#.3= '7'; @.3=  ..1111111111111111111111111111111111111111111111111111111111111117777888
#.4=  . ; @.4= "I never give 'em hell, I just tell the truth, and they think it's hell. "
#.5= ' '; @.5= '                                                   ---  Harry S Truman  '
#.6= '-'; @.6= @.5
#.7= 'r'; @.7= @.5

     do j=1;    L= length(@.j)                   /*obtain the length of an array element*/
     say copies('═', 105)                        /*show a separator line between outputs*/
     if j>1  &  L==0     then leave              /*if arg is null and  J>1, then leave. */
     say '    specified immediate repeatable character='     #.j      "   ('"c2x(#.j)"'x)"
     say '    length='right(L, 3)     "   input=«««" || @.j || '»»»'
     new= squeeze(@.j, #.j)
       w= length(new)
     say '    length='right(w, 3)     "  output=«««" || new || '»»»'
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
squeeze: procedure; parse arg y 1 $ 2,z          /*get string; get immed. repeated char.*/
         if pos(z || z, y)==0  then return y     /*No repeated immediate char?  Return Y*/
                                                 /* [↑]  Not really needed;  a speed─up.*/
                     do k=2  to length(y)        /*traipse through almost all the chars.*/
                     _= substr(y, k, 1)                      /*pick a character from  Y */
                     if _==right($, 1) & _==z then iterate   /*Same character?  Skip it.*/
                     $= $ || _                               /*append char., it's diff. */
                     end     /*j*/
         return $
