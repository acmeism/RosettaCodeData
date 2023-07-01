/*REXX program  generates and displays a  number triangle  for partitions of a number.  */
numeric digits 400                               /*be able to handle larger numbers.    */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N==''  then N= 25                             /*N  specified?  Then use the default. */
@.= 0;          @.0= 1;       aN= abs(N)         /*initialize a partition number; AN abs*/
if N==N+0  then say  '         G('aN"):"   G(N)  /*just do this for well formed numbers.*/
                say  'partitions('aN"):"   partitions(aN)          /*do it the easy way.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
G: procedure; parse arg nn;  !.= 0;    !.4.2= 2;     mx= 1;    aN= abs(nn);    build= nn>0
                do j=1  for aN%2;      !.j.j= 1      /*gen shortcuts for unity elements.*/
                end   /*j*/

                do     t=1  for 1+build;        #.=1 /*generate triangle once or twice. */
                  do   r=1  for aN;   #.2= r % 2     /*#.2  is a shortcut calculation.  */
                    do c=3  to  r-2;  #.c= gen#(r,c)
                    end   /*c*/
                  L= length(mx);      p= 0;     __=  /*__  will be a row of the triangle*/
                      do cc=1  for r; p= p + #.cc    /*only sum the last row of numbers.*/
                      if \build  then iterate        /*should we skip building triangle?*/
                      mx= max(mx, #.cc)              /*used to build the symmetric #s.  */
                      __= __  right(#.cc, L)         /*construct a row of the triangle. */
                      end   /*cc*/
                  if t==1  then iterate              /*Is this 1st time through? No show*/
                  say  center( strip(__),  2 + (aN-1) * (length(mx) + 1) )
                  end       /*r*/                    /* [↑]  center row of the triangle.*/
                end         /*t*/
              return p                               /*return with the generated number.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen#: procedure expose !.;   parse arg x,y             /*obtain the  X and Y  arguments.*/
      if !.x.y\==0  then  return !.x.y                 /*was number generated before ?  */
      if y>x%2  then do;  nx= x+1-(y-x%2)*2-(x//2==0)
                          ny= nx % 2;  !.x.y= !.nx.ny
                          return !.x.y                 /*return the calculated number.  */
                     end                               /* [↑]  right half of triangle.  */
      $= 1                                             /* [↓]   left   "   "     "      */
                          do q=2  for y-1;   xy= x-y;   if q>xy  then iterate
                          if q==2  then $= $  +  xy % 2
                                   else if q==xy-1  then $= $ + 1
                                                    else $= $ + gen#(xy,q)    /*recurse.*/
                          end   /*q*/
      !.x.y=$; return $                                /*use memoization; return with #.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
partitions: procedure expose @.; parse arg n;   if @.n\==0  then return @.n   /* ◄─────┐*/
            $= 0                                         /*Already known?  Return ►────┘*/
                     do k=1  for n                       /*process  N  partitions.      */
                     #= n - (k*3-1) * k % 2              /*calculate a partition number.*/
                     if #<0  then leave                  /*Is it negative?  Then leave. */
                     if @.#==0  then x= partitions(#)    /* [◄] this is a recursive call*/
                                else x= @.#              /*the value is already known.  */
                     #= # - k
                     if #<0  then  y= 0                  /*Is negative?   Then use zero.*/
                             else  if @.#==0  then y= partitions(p)    /*recursive call.*/
                                              else y= @.#
                     if k//2  then $= $ + x + y          /*use this method if K is odd. */
                              else $= $ - x - y          /* "    "     "    " "  " even.*/
                     end   /*k*/                         /* [↑]  Euler's recursive func.*/
            @.n= $;             return $                 /*use memoization;  return num.*/
