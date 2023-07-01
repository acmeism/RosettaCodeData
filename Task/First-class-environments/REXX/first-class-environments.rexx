/*REXX pgm illustrates  N  1st─class environments  (using numbers from a hailstone seq).*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 12                    /*Was N defined?  No, then use default.*/
@.=                                              /*initialize the array   @.  to  nulls.*/
                   do i=1  for n;    @.i= i      /*    "      environments to an index. */
                   end   /*i*/
w= length(n)                                     /*width  (so far)  for columnar output.*/

         do forever  until @.0;  @.0= 1          /* ◄─── process all the environments.  */
            do k=1  for n;       x= hailstone(k) /*obtain next hailstone number in seq. */
            w= max(w, length(x))                 /*determine the maximum width needed.  */
            @.k= @.k  x                          /* ◄─── where the rubber meets the road*/
            end   /*k*/
         end      /*forever*/
#= 0                                             /* [↓]   display the tabular results.  */
      do lines=-1  until _='';     _=            /*process a line for each environment. */
          do j=1  for n                          /*process each of the environments.    */
              select                             /*determine how to process the line.   */
              when #== 1      then _= _ right(words(@.j) - 1, w)    /*environment count.*/
              when lines==-1  then _= _ right(j,  w)                /*the title (header)*/
              when lines== 0  then _= _ right('', w, "─")           /*the separator line*/
              otherwise            _= _ right(word(@.j, lines), w)
              end   /*select*/
          end       /*j*/

      if #==1   then #= 2                                           /*separator line?   */
      if _=''   then #= # + 1                                       /*Null?  Bump the #.*/
      if #==1   then _= copies(" "left('', w, "═"), N)              /*the foot separator*/
      if _\=''  then say strip( substr(_, 2), "T")                  /*display the counts*/
      end   /*lines*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hailstone: procedure expose @.; parse arg y;       _= word(@.y, words(@.y) )
           if _==1  then return '';   @.0= 0;   if _//2  then return _*3 + 1;   return _%2
