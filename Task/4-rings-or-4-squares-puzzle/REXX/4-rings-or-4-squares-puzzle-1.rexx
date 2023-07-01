/*REXX pgm solves the 4-rings puzzle,  where letters represent unique (or not) digits). */
arg LO HI unique show .                          /*the  ARG  statement capitalizes args.*/
if LO=='' | LO==","  then LO=1                   /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI=7                   /* "      "         "   "   "     "    */
if unique=='' | unique==',' | unique=='UNIQUE'  then unique=1  /*unique letter solutions*/
                                                else unique=0  /*non-unique        "    */
if   show=='' |   show==',' |   show=='SHOW'    then show=1    /*noshow letter solutions*/
                                                else show=0    /*  show    "       "    */
w=max(3, length(LO), length(HI) )                /*maximum width of any number found.   */
bar=copies('═', w)                               /*define a horizontal bar (for title). */
times=HI - LO + 1                                /*calculate number of times to loop.   */
#=0                                              /*number of solutions found (so far).  */
       do a=LO     for times
          do b=LO  for times
          if unique  then  if b==a  then  iterate
             do c=LO  for times
             if unique  then  do;  if c==a  then  iterate
                                   if c==b  then  iterate
                              end
                do d=LO  for times
                if unique  then  do;  if d==a  then  iterate
                                      if d==b  then  iterate
                                      if d==c  then  iterate
                                 end
                   do e=LO  for times
                   if unique  then  do;  if e==a  then  iterate
                                         if e==b  then  iterate
                                         if e==c  then  iterate
                                         if e==d  then  iterate
                                    end
                      do f=LO  for times
                      if unique  then  do;  if f==a  then  iterate
                                            if f==b  then  iterate
                                            if f==c  then  iterate
                                            if f==d  then  iterate
                                            if f==e  then  iterate
                                       end
                         do g=LO  for times
                         if unique  then  do;  if g==a  then  iterate
                                               if g==b  then  iterate
                                               if g==c  then  iterate
                                               if g==d  then  iterate
                                               if g==e  then  iterate
                                               if g==f  then  iterate
                                          end
                         sum=a+b
                         if   f+g\==sum  then  iterate
                         if b+c+d\==sum  then  iterate
                         if d+e+f\==sum  then  iterate
                         #=# + 1                          /*bump the count of solutions.*/
                         if #==1  then call align  'a',  'b',  'c',  'd',  'e',  'f',  'g'
                         if #==1  then call align  bar,  bar,  bar,  bar,  bar,  bar,  bar
                                       call align   a,    b,    c,    d,    e,    f,    g
                         end   /*g*/
                      end      /*f*/
                   end         /*e*/
                end            /*d*/
             end               /*c*/
          end                  /*b*/
       end                     /*a*/
say
                 _= ' non-unique'
if  unique  then _= ' unique '
say #  _  'solutions found.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
align: parse arg a1,a2,a3,a4,a5,a6,a7
       if show  then say left('',9)  center(a1,w) center(a2,w) center(a3,w) center(a4,w),
                                     center(a5,w) center(a6,w) center(a7,w)
       return
