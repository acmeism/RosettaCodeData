/*REXX program generates & displays primitive Heronian triangles by side length and area*/
parse arg  N  first  area  .                     /*obtain optional arguments from the CL*/
if     N==''  |     N==","  then     N= 200      /*Not specified?  Then use the default.*/
if first==''  | first==","  then first=  10      /* "      "         "   "   "     "    */
if  area==''  |  area==","  then  area= 210      /* "      "         "   "   "     "    */
numeric digits 99                                /*ensure 'nuff dec. digs to calc. N**5.*/
numeric digits max(9, 1 + length(N**5) )         /*minimize decimal digits for REXX pgm.*/
call Heron;       HT= 'Heronian triangles'       /*invoke the  Heron  subroutine.       */
say  #          ' primitive'  HT  "found with sides up to "   N  ' (inclusive).'
call show     , 'Listing of the first '      first      ' primitive'      HT":"
call show area, 'Listing of the (above) found primitive'   HT   "with an area of "    area
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Heron: @.= 0;  minP= 9e9;  maxP= 0;  maxA= 0;  minA= 9e9;  Ln= length(N)    /*        __*/
               #= 0;  #.= 0;  #.2= 1;  #.3= 1;  #.7= 1;  #.8= 1       /*digits ¬good √  */
  do a=3  to N                                   /*start at a minimum side length of 3. */
           Aeven= a//2==0                        /*if  A  is even,  B and C must be odd.*/
    do b=a+Aeven  to N  by 1+Aeven;   ab= a + b  /*AB: a shortcut for the sum of A & B. */
    if b//2==0  then                bump= 1      /*Is  B  even?       Then  C  is odd.  */
                else if Aeven  then bump= 0      /*Is  A  even?         "   "   "  "    */
                               else bump= 1      /*A and B  are both odd,  biz as usual.*/
      do c=b+bump  to N  by 2;   s= (ab + c) % 2 /*calculate triangle's perimeter:   S. */
      _= s*(s-a)*(s-b)*(s-c); if _<=0   then iterate /*is  _  not positive?      Skip it*/
      parse var _ '' -1 z   ; if #.z    then iterate /*Last digit not square?    Skip it*/
      ar= hIsqrt(_);       if ar*ar\==_ then iterate /*Is area not an integer?   Skip it*/
      if hGCD(a, b, c) \== 1            then iterate /*GCD of sides not equal 1? Skip it*/
      #= # + 1;                p= ab + c             /*primitive Heronian triangle.     */
      minP= min( p, minP);     maxP= max( p, maxP);        Lp= length(maxP)
      minA= min(ar, minA);     maxA= max(ar, maxA);        La= length(maxA)
      _=@.ar.p.0 + 1                                 /*bump Heronian triangle counter.  */
      @.ar.p.0= _;  @.ar.p._= right(a, Ln)   right(b, Ln)   right(c, Ln)       /*unique.*/
      end   /*c*/                                    /* [↑]  keep each unique perimeter#*/
    end     /*b*/
  end       /*a*/;             return #              /*return # of Heronian triangles.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hGCD: x=a;   do j=2  for 2;    y= arg(j);       do until y==0; parse value x//y y with y x
                                                end   /*until*/
             end   /*j*/;      return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
hIsqrt: procedure; parse arg x;  q= 1;  r= 0;                  do  while q<=x;    q= q * 4
                                                               end   /*while q<=x*/
          do  while q>1; q=q%4; _= x-r-q; r= r%2; if _>=0  then parse value _ r+q with x r
          end   /*while q>1*/;          return r
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: m=0;  say;  say;   parse arg ae;     say arg(2);         if ae\==''  then first= 9e9
      say;  $=left('',9);   $a= $"area:";  $p= $'perimeter:';  $s= $"sides:"  /*literals*/
            do   i=minA  to maxA;  if ae\=='' & i\==ae  then iterate          /*= area? */
              do j=minP  to maxP  until m>=first      /*only display the  FIRST entries.*/
                do k=1  for @.i.j.0;    m= m + 1      /*display each  perimeter  entry. */
                say right(m, 9)   $a    right(i, La)    $p   right(j, Lp)    $s    @.i.j.k
                end   /*k*/
              end     /*j*/                           /* [↑]  use the known perimeters. */
            end       /*i*/;            return        /* [↑]  show any found triangles. */
