/*REXX program generates & shows a number triangle for partitions of a number.*/
numeric digits 400                     /*be able to handle larger numbers.    */
parse arg N .;  if N==''  then N=25    /*N  specified?  Then use the default. */
@.=0;     @.0=1;          aN=abs(N)
if N==N+0  then say  '         G('aN"):"  G(N) /*just for well formed numbers.*/
                say  'partitions('aN"):"  partitions(aN)  /*do it the easy way*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────G subroutine──────────────────────────────*/
G: procedure;  parse arg nn;    !.=0;     mx=1;   aN=abs(nn);   build=nn>0
!.4.2=2;       do j=1  for aN%2;  !.j.j=1;   end  /*j*/       /*gen shortcuts.*/

         do     t=1  for 1+build;  #.=1       /*gen triangle once or twice ···*/
           do   r=1  for aN;       #.2=r%2    /*#.2 is a shortcut calculation.*/
             do c=3  to  r-2; #.c=gen#(r,c);  end  /*c*/
           L=length(mx);    p=0;  __=  /*__  will be a row (line) of triangle.*/
               do cc=1  for r          /*only sum the last row of numbers.    */
               p=p+#.cc                /*add the last row of the triangle.    */
               if \build  then iterate /*should we skip building the triangle?*/
               mx=max(mx,#.cc)         /*used to build the symmetric numbers. */
               __=__ right(#.cc,L)     /*construct a row (or line) of triangle*/
               end   /*cc*/
           if t==1  then iterate       /*Is this the 1st time through? No show*/
           say  center(strip(__), 2+(aN-1)*(length(mx)+1))
           end       /*r*/             /* [↑]  center the row of the triangle.*/
         end         /*t*/
return p                               /*return with the generated number.    */
/*──────────────────────────────────GEN# subroutine───────────────────────────*/
gen#: procedure expose !.;   parse arg x,y      /*obtain  X and Y  arguments. */
if !.x.y\==0  then  return !.x.y                /*was number generated before?*/
if y>x%2  then do;  nx=x+1-2*(y-x%2)-(x//2==0);     ny=nx%2;       !.x.y=!.nx.ny
                    return !.x.y                /*return the calculated number*/
               end                              /* [↑]  right half of triangle*/
$=1                                             /* [↓]   left   "   "    "    */
                    do q=2  for  y-1;   xy=x-y;   if q>xy  then iterate
                    if q==2  then $=$+xy%2
                             else if q==xy-1  then $=$+1
                                              else $=$+gen#(xy,q)   /*recurse.*/
                    end   /*q*/
!.x.y=$; return $                      /*use memoization;  return with number.*/
/*──────────────────────────────────PARTITIONS subroutine─────────────────────*/
partitions: procedure expose @.; parse arg n; if @.n\==0 then return @.n /*◄─┐*/
$=0                                    /*Already known? Then return value►───┘*/
                do k=1  for n;  _=n-(k*3-1)*k%2;       if _<0  then leave
                if @._==0  then x=partitions(_)        /* [◄]  recursive call.*/
                           else x=@._                  /*value already known. */
                _=_-k;   if _<0  then  y=0             /*recursive call ►────┐*/
                                 else  if @._==0  then y=partitions(_)  /*◄──┘*/
                                                  else y=@._
                if k//2  then $=$+x+y  /*utilize this method if  K  is  odd.  */
                         else $=$2x-y  /*   "      "     "    "  "   "  even. */
                end   /*k*/            /* [↑]  Euler's recursive function.    */
@.n=$; return $                        /*use memoization;  return with number.*/
