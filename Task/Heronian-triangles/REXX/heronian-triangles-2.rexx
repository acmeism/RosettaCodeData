/*REXX program generates & displays primitive Heronian triangles by side length and area*/
parse arg  N  first  area  .                     /*obtain optional arguments from the CL*/
if     N==''  |     N==","  then     N=200       /*Not specified?  Then use the default.*/
if first==''  | first==","  then first= 10       /* "      "         "   "   "     "    */
if  area==''  |  area==","  then  area=210       /* "      "         "   "   "     "    */
numeric digits 99; numeric digits max(9, 1+length(N**5))  /*ensure 'nuff decimal digits.*/
call Heron;       HT= 'Heronian triangles'       /*invoke the  Heron  subroutine.       */
say  #          ' primitive'    HT    "found with sides up to "     N      ' (inclusive).'
call show     , 'Listing of the first '       first        ' primitive'            HT":"
call show area, 'Listing of the (above) found primitive'   HT   "with an area of "    area
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Heron: @.=0;  #=0;  !.=.;  minP=9e9;  maxA=0; maxP=0; minA=9e9;  Ln=length(N)  /*   __  */
                    do i=5  to N**2%2; _=i*i; !._=i; end   /*pre-calculate a fast  √    */
  do     a=3  to N                               /*start at a minimum side length of 3. */
  even= (a//2==0)                                /*if  A  is even,  B and C must be odd.*/
    do   b=a+even  to N  by 1+even;   ab=a + b             /*AB:  is a shortcut sum.    */
    if b//2==0  then                  bump=1               /*B is even?  Then C is odd. */
                else    if even  then bump=0               /*A is even?    "  "  "  "   */
                                 else bump=1               /*A & B odd,  biz as usual.  */
      do c=b+bump  to N  by 2;        s=(ab + c) % 2       /*calculate perimeter:   S.  */
      _=s*(s-a)*(s-b)*(s-c);  if !._==.     then iterate   /*Is  _  not a square?  Skip.*/
      ar=!._;                 if ar*ar\==_  then iterate   /*Area not an integer?  Skip.*/
      if hGCD(a,b,c) \== 1                  then iterate   /*GCD of sides not 1?   Skip.*/
      #=# + 1;     p=ab + c                                /*primitive Heronian triangle*/
      minP=min( p, minP);     maxP=max( p, maxP);      Lp=length(maxP)
      minA=min(ar, minA);     maxA=max(ar, maxA);      La=length(maxA);        @.ar=
      _=@.ar.p.0 + 1                                       /*bump the triangle counter. */
      @.ar.p.0=_;    @.ar.p._=right(a, Ln)    right(b, Ln)    right(c, Ln)     /*unique.*/
      end   /*c*/                                /* [↑]  keep each unique perimeter #.  */
    end     /*b*/
  end       /*a*/
return #                                         /*return number of Heronian triangles. */
/*────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
hGCD: procedure; parse arg x; do j=2 for 2; y=arg(j); do until y==0; parse value x//y y with y x; end; end; return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: m=0;  say;  say;   parse arg ae;    say arg(2);          if ae\==''  then first=9e9
      say;  $=left('',9);   $a=$"area:";  $p=$'perimeter:';   $s=$"sides:"    /*literals*/
            do   i=minA  to maxA;  if ae\=='' & i\==ae  then iterate          /*= area? */
              do j=minP  to maxP  until m>=first      /*only display the  FIRST entries.*/
                do k=1  for @.i.j.0;    m=m+1         /*display each  perimeter  entry. */
                say right(m,9)    $a    right(i, La)    $p   right(j, Lp)    $s    @.i.j.k
                end   /*k*/
              end     /*j*/                           /* [↑]  use the known perimeters. */
            end       /*i*/                           /* [↑]  show any found triangles. */
      return
