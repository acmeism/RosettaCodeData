/*REXX program obtains/displays Catalan numbers from  Pascal's triangle.*/
parse arg N .;   if N==''  then N=15   /*Any args?  No, then use default*/
numeric digits max(9,N*4)              /*can handle huge Catalan numbers*/
!.=.
     do j=1  for N                     /* [↓]  show   N  Catalan numbers*/
     say  comb(j+j,j) % (j+1)          /*display the Jth Catalan number.*/
     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────! (factorial) function──────────────*/
!: procedure expose !.;   parse arg z;    if !.z\==. then return !.z;  _=1
      do j=1  for arg(1); _=_*j; end;        !.z=_;       return _
/*──────────────────────────────────COMB (binomial coefficient) function*/
comb: procedure expose !.;  parse arg x,y;  if x=y then return 1
if y>x   then return 0
if x-y<y then y=x-y; _=1;   do j=x-y+1  to x; _=_*j; end;    return _/!(y)
