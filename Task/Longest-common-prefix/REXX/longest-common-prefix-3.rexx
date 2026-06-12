/*REXX program  computes the   longest common prefix  (LCP)   of any number of  strings.*/
say LCP('interspecies',  "interstellar",  'interstate')
say LCP('throne',  "throne")                     /*2 strings, they are exactly the same.*/
say LCP('throne',  "dungeon")                    /*2 completely different strings.      */
say LCP('throne',  '',   "throne")               /*3 strings, the middle string is null.*/
say LCP('cheese')                                /*just a single cheesy argument.       */
say LCP('')                                      /*just a single  null  argument.       */
say LCP()                                        /*no arguments are specified at all.   */
say LCP('prefix',  "suffix")                     /*two mostly different strings.        */
say LCP('foo',     "foobar")                     /*two mostly similar strings.          */
say LCP('a',  "b",  'c',  "aaa")                 /*four strings, mostly different.      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LCP: @= arg(1);  m= length(@);      #=arg();       say copies('▒', 60)
                 say '──────────────     number of strings specified:'  #
                        do i=1  for #;  say '────────────── string' i":"  showNull(arg(i))
                        end   /*i*/

                    do j=2  to #;    x= arg(j);    t= compare(@, x)   /*compare to next.*/
                    if t==1 | x==''  then do;   @=;   leave;   end    /*mismatch of strs*/
                    if t==0 & @==x   then t= length(@) + 1            /*both are equal. */
                    if t>=m          then iterate                     /*not longest str.*/
                    m= t - 1;        @= left(@, max(0, m) )           /*define maximum. */
                    end   /*j*/
     return  '  longest common prefix='    shownull(@)                /*return answer.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showNull: procedure;   parse arg z;        if z==''  then z= "«null»";         return z
