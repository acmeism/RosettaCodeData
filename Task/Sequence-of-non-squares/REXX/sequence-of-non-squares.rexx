/*REXX program displays some  non─square numbers,  and also displays a validation check.*/
parse arg N M .                                  /*obtain optional arguments from the CL*/
if N=='' | N==","  then N=      22               /*Not specified?  Then use the default.*/
if M=='' | M==","  then M= 1000000               /* "      "         "   "   "     "    */
say 'The first '    N    " non-square numbers:"  /*display a header of what's to come.  */
say                                              /* [↑]  default for  M  is one million.*/
say center('index', 20)        center('non-square numbers', 20)
say center(''     , 20, "═")   center(''                  , 20, "═")
          do j=1  for N
          say  center(j, 20)   center(j +floor(1/2 +sqrt(j)), 20)  /*could use  (.5+ ···*/
          end   /*j*/
#oops=0
          do k=1  for abs(M-1)                   /*have it step through a million of 'em*/
          $= k + floor( .5 + sqrt(k) )           /*use the specified formula (algorithm)*/
          iRoot=iSqrt($)                         /*··· and also use the  ISQRT function.*/
          if iRoot*iRoot==$  then #oops=#oops+1  /*have we found a mistook?  (sic)      */
          end   /*k*/
say;                               if #oops==0  then #oops= 'no'   /*use gooder English.*/
say 'Using the formula:  floor[ 1/2 +  sqrt(n) ], '  #oops  " squares found up to "   M'.'
                                                 /* [↑]  display (possible) error count.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
floor: procedure; parse arg x;            return trunc( x - (x<0) )
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  x=trunc(x);  r=0;  q=1;     do  while q<=x;   q=q*4;   end
         do  while q>1;  q=q%4;  _=x-r-q;  r=r%2;  if _>=0  then do; x=_; r=r+q; end;  end
       return r                                  /*return the integer square root of  X.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x; if x=0 then return 0; d=digits(); m.=9; numeric form; h=d+6
       numeric digits;  parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .; g=g *.5'e'_ %2
                 do j=0  while h>9;       m.j=h;                h=h%2+1;        end /*j*/
                 do k=j+5  to 0  by -1;   numeric digits m.k;   g=(g+x/g)*.5;   end /*k*/
       return g
