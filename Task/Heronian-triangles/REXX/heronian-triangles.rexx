/*REXX pgm generates primitive Heronian triangles by side length & area.*/
parse arg  N  first  area  .                /*get optional  N  (sides). */
if     N==''  |     N==','  then     N=200  /*maybe use the default.    */
if first==''  | first==','  then first= 10  /*  "    "   "     "        */
if  area==''  |  area==','  then  area=210  /*  "    "   "     "        */
numeric digits 99; numeric digits max(9, 1+length(N**5))  /*ensure 'nuff*/
call Heron                                  /*invoke Heron subroutine.  */
say  #          ' primitive Heronian triangles found with sides up to '   N   " (inclusive)."
call show     , 'listing of the first '    first    ' primitive Heronian triangles:'
call show area, 'listing of the (above) found primitive Heronian triangles with an area of ' area
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HERON subroutine────────────────────*/
Heron:  @.=.;    #=0;    minP=9e9;  maxP=0; minA=9e9; maxA=0; Ln=length(N)
                         #.=0;  #.2=1  #.3=1;  #.7=1;  #.8=1  /*¬good √.*/
  do     a=3  to N                     /*start at a minimum side length.*/
  ev= \ (a//2);           inc=1+ev     /*if A is even, B & C must be odd*/
    do   b=a+ev  to N  by inc; ab=a+b  /*AB:  is used for summing below.*/
      do c=b     to N  by inc; p=ab+c;     s=p/2     /*calc Perimeter, S*/
      _=s*(s-a)*(s-b)*(s-c); if _<=0  then iterate   /*_ isn't positive.*/
      if pos(.,_)\==0                 then iterate   /*not an integer.  */
      parse var _ '' -1 q  ; if #.q   then iterate   /*not good square. */
      ar=iSQRT(_);     if ar*ar\==_   then iterate   /*area not integer.*/
      if hGCD(a,b,c)\==1              then iterate   /*GCD of sides ¬1. */
      #=#+1                                          /*got prim. H. tri.*/
      minP=min( p,minP);   maxP=max( p,maxP);     Lp=length(maxP)
      minA=min(ar,minA);   maxA=max(ar,maxA);     La=length(maxA);   @.ar=
      if @.ar.p.0==.  then @.ar.p.0=0;  _=@.ar.p.0+1 /*bump triangle ctr*/
      @.ar.p.0=_;  @.ar.p._=right(a,Ln) right(b,Ln) right(c,Ln) /*unique*/
      end   /*c*/                      /* [↑]  keep each unique P items.*/
    end     /*b*/
  end       /*a*/
return #                               /*return # of Heronian triangles.*/
/*──────────────────────────────────HGCD subroutine─────────────────────*/
hGCD: procedure; parse arg x; do j=2  for 2 /*sub handles exactly 3 args*/
y=arg(j);  do  until y==0; parse value x//y y with y x; end; end; return x
/*──────────────────────────────────ISQRT subroutine────────────────────*/
iSQRT: procedure;  parse arg x; x=x%1; if x==0 | x==1  then return x;  q=1
  do while q<=x; q=q*4; end;     r=0        /*Q will be > X at loop end.*/
  do while q>1 ; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q;end; end
return r                                    /* R  is a postive integer. */
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show: m=0; say; say; parse arg ae; say arg(2);  if ae\==''  then first=9e9
say;                          y=left('',9)  /* [↓]   skip the nothings. */
      do   i=minA  to maxA;   if @.i==.  then iterate
      if ae\=='' & i\==ae   then iterate    /*Area specified? Then check*/
        do j=minP  to maxP  until m>=first  /*only list  FIRST  entries.*/
        if @.i.j.0==.       then iterate    /*Not defined? Then skip it.*/
          do k=1  for @.i.j.0;   m=m+1      /*visit each perimeter entry*/
          say right(m,9) y'area:' right(i,La) y"perimeter:" right(j,Lp) y'sides:' @.i.j.k
          end   /*k*/
        end     /*j*/                       /* [↑]  use known perimeters*/
      end       /*i*/                       /* [↑]  show found triangles*/
return
