/*REXX program generates a number triangle for  partitions  of a number.*/
numeric digits 400                     /*be able to handle large numbers*/
parse arg N .;  if N==''  then N=25    /*No input?  Then use the default*/
@.=0;     @.0=1;          aN=abs(N)
if N==N+0  then say  '         G('aN"):"  G(N) /*just for well formed #s*/
                say  'partitions('aN"):"  partitions(aN)  /*the easy way*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────G subroutine────────────────────────*/
G: procedure;  parse arg nn;    !.=0;     mx=1;   aN=abs(nn);   build=nn>0
!.4.2=2;       do j=1  for aN%2;  !.j.j=1;   end  /*j*/     /*shortcuts.*/

         do     t=1  for 1+build;  #.=1 /*gen triangle once or twice ∙∙∙*/
           do   r=1  for aN;       #.2=r%2     /*#.2 is a shortcut calc.*/
             do c=3  to  r-2; #.c=gen#(r,c);   end  /*c*/
           L=length(mx);      p=0;     aLine=
             do cc=1  for r            /*only sum last row of numbers.  */
             p=p+#.cc                  /*add last row of the triangle.  */
             if \build  then iterate   /*skip building the triangle?    */
             mx=max(mx,#.cc)           /*used to build symmetric numbers*/
             aLine=aLine right(#.cc,L) /*build a row of the triangle.   */
             end   /*cc*/
           if t==1  then iterate       /*Is first time through?  No show*/
           L=length(mx);     say  centre(strip(aLine,'L'), 2+(aN-1)*(L+1))
           end     /*r*/               /* [↑] centre the row (triangle).*/
         end       /*t*/
return p                               /*return with generated number.  */
/*──────────────────────────────────GEN# subroutine─────────────────────*/
gen#: procedure expose !.;  parse arg x,y    /*obtain X and Y arguments.*/
if !.x.y\==0  then  return !.x.y       /*was this # generated before?   */
if y>x%2  then do;  nx=x+1-2*(y-x%2)-(x//2==0);   ny=nx%2;   !.x.y=!.nx.ny
               return !.x.y            /*return with the calculated num.*/
               end                     /*[↑] right half of the triangle.*/
$=1                                    /*[↓]  left half of the triangle.*/
                   do q=2  to y;   xy=x-y;   if q>xy  then iterate
                   if q==2  then $=$+xy%2
                            else if q==xy-1  then $=$+1
                                             else $=$+gen#(xy,q)
                   end   /*q*/
!.x.y=$; return $                      /*remember #, return with number.*/
/*──────────────────────────────────PARTITIONS subroutine───────────────*/
partitions: procedure expose @.;       parse arg n
if @.n\==0  then return @.n            /*Already computed?   Return it. */
$=0                                    /*[↓] Euler's recursive function.*/
                 do k=1  for n;  _=n-(k*3-1)*k%2;      if _<0  then leave
                 if @._==0  then x=partitions(_);  else x=@._
                 _=_-k;     if _<0  then  y=0
                                    else  if @._==0   then y=partitions(_)
                                                      else y=@._
                 if k//2  then $=$+x+y /*sum this way if  K  is odd  ···*/
                          else $=$-x-y /* "    "   "   "  "   " even ···*/
                 end   /*k*/
@.n=$; return $
