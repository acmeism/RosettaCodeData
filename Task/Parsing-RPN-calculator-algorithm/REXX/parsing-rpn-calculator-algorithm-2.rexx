/*REXX program  evaluates  a   ═════ Reverse Polish notation  (RPN) ═════   expression. */
parse arg x                                      /*obtain optional arguments from the CL*/
if x=''  then x= "3 4 2 * 1 5 - 2 3 ^ ^ / +"     /*Not specified?  Then use the default.*/
tokens=words(x)                                  /*save the  number  of  tokens   "  ". */
showSteps=1                                      /*set to 0 if working steps not wanted.*/
ox=x                                             /*save the  original  value of  X.     */
            do i=1  for tokens;   @.i=word(x,i)  /*assign the input tokens to an array. */
            end   /*i*/
x=space(x)                                       /*remove any superfluous blanks in  X. */
L=max(20, length(x))                             /*use 20 for the minimum display width.*/
numeric digits L                                 /*ensure enough decimal digits for ans.*/
say center('operand', L, "─")        center('stack', L+L, "─")           /*display title*/
$=                                               /*nullify the stack (completely empty).*/
       do k=1  for tokens;   ?=@.k;   ??=?       /*process each token from the  @. list.*/
       #=words($)                                /*stack the count (the number entries).*/
       if datatype(?,'N')  then do;  $=$ ?;   call show  "add to───►stack";  iterate;  end
       if ?=='^'           then ??= "**"         /*REXXify    ^ ───► **    (make legal).*/
       interpret 'y='word($,#-1)  ??  word($,#)  /*compute via the famous REXX INTERPRET*/
       if datatype(y,'N')  then y=y/1            /*normalize the number with ÷ by unity.*/
       $=subword($, 1, #-2)     y                /*rebuild the stack with the answer.   */
       call show ?                               /*display steps (tracing into),  maybe.*/
       end   /*k*/
say                                              /*display a blank line, better perusing*/
say ' RPN input:'  ox;   say "  answer──►"$      /*display original input;  display ans.*/
parse source upper . y .                         /*invoked via  C.L.  or via a REXX pgm?*/
if y=='COMMAND' | \datatype($,"W")  then exit    /*stick a fork in it,  we're all done. */
                                    else exit $  /*return the answer  ───►  the invoker.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: if showSteps  then say center(arg(1), L)            left(space($), L);        return
