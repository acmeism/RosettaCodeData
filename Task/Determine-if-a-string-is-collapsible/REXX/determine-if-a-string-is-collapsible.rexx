/*REXX program "collapses" all immediately repeated characters in a string (or strings).*/
@.=                                              /*define a default for the  @.  array. */
parse arg x                                      /*obtain optional argument from the CL.*/
if x\=''  then      @.1= x                       /*if user specified an arg, use that.  */
          else do;  @.1=
                    @.2= '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln '
                    @.3=  ..1111111111111111111111111111111111111111111111111111111111111117777888
                    @.4= "I never give 'em hell, I just tell the truth, and they think it's hell. "
                    @.5= '                                                   ---  Harry S Truman  '
               end

     do j=1;    L= length(@.j)                   /*obtain the length of an array element*/
     say copies('═', 105)                        /*show a separator line between outputs*/
     if j>1  &  L==0     then leave              /*if arg is null and  J>1, then leave. */
     new= collapse(@.j)
     say 'string' word("isn't is",1+collapsible) 'collapsible' /*display semaphore value*/
     say '    length='right(L, 3)     "   input=«««"  ||  @.j  ||  '»»»'
       w= length(new)
     say '    length='right(w, 3)     "  output=«««"  ||  new  ||  '»»»'
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
collapse: procedure expose collapsible; parse arg y 1 $ 2  /*get the arg; get 1st char. */
            do k=2  to length(y)                 /*traipse through almost all the chars.*/
            _= substr(y, k, 1)                   /*pick a character from  Y  (1st arg). */
            if _==right($, 1)  then iterate      /*Is this the same character?  Skip it.*/
            $= $ || _                            /*append the character, it's different.*/
            end   /*j*/
          collapsible= y\==$;       return $     /*set boolean to  true  if collapsible.*/
