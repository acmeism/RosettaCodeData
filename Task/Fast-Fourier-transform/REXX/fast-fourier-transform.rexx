/*REXX pgm performs a fast Fourier transform (FFT) on a set of complex numbers*/
numeric digits length( pi() )   - 1    /*limited by the  PI  function result. */
arg data                               /*ARG verb uppercases the DATA from CL.*/
if data=''  then data=1 1 1 1 0        /*Not specified?  Then use the default.*/
size=words(data);    pad=left('',6)    /*PAD:  for indenting and padding SAYs.*/
  do p=0  until  2**p>=size      ; end /*number of args exactly a power of 2? */
  do j=size+1 to 2**p;data=data 0; end /*add zeroes to DATA 'til a power of 2.*/
size=words(data);   ph=p%2;   call hdr       /*╔═════════════════════════════╗*/
             /* [↓] TRANSLATE allows I&J*/   /*║ Numbers in  data  can be in ║*/
     do j=0  for size                        /*║ seven formats:    real      ║*/
     _=translate(word(data,j+1), 'J', "I")   /*║                   real,imag ║*/
     parse  var  _   #.1.j '' $ 1 ',' #.2.j  /*║                       ,imag ║*/
     if $=='J'  then parse var #.1.j #2.j ,  /*║                        nnnJ ║*/
                               "J"  #.1.j    /*║                        nnnj ║*/
       do m=1  for  2; #.m.j=word(#.m.j 0,1) /*║                        nnnI ║*/
       end   /*m*/   /* [↑] ommited part?*/  /*║                        nnni ║*/
                                             /*╚═════════════════════════════╝*/
     say pad " FFT   in "    center(j+1,7)    pad   fmt(#.1.j)    fmt(#.2.j,'i')
     end     /*j*/
say
tran=pi()*2/2**p;     !.=0;     hp=2**p%2;     A=2**(p-ph);     ptr=A;     dbl=1
say
    do p-ph;        halfPtr=ptr%2
               do i=halfPtr  by ptr  to A-halfPtr;    _=i-halfPtr;   !.i=!._+dbl
               end   /*i*/
    dbl=dbl*2;               ptr=halfPtr
    end   /*p-ph*/

             do j=0  to 2**p%4;  cmp.j=cos(j*tran);    _=hp - j;   cmp._= -cmp.j
                                                       _=hp + j;   cmp._= -cmp.j
             end  /*j*/
B=2**ph

  do i=0     for A;            q=i * B
      do j=0 for B;   h=q+j;   _=!.j*B+!.i;  if _<=h  then iterate
      parse value  #.1._  #.1.h  #.2._  #.2.h   with  #.1.h  #.1._  #.2.h  #.2._
      end   /*j*/                             /* [↑]  swap two sets of values.*/
  end       /*i*/

dbl=1;       do p                 ;    w=hp % dbl
               do k=0   for dbl   ;   Lb=w * k            ;    Lh=Lb + 2**p % 4
                 do j=0 for w     ;    a=j * dbl * 2 + k  ;     b= a + dbl
                 r=#.1.a; i=#.2.a ;   c1=cmp.Lb * #.1.b   ;    c4=cmp.Lb * #.2.b
                                      c2=cmp.Lh * #.2.b   ;    c3=cmp.Lh * #.1.b
                                   #.1.a=r + c1 - c2      ; #.2.a=i + c3 + c4
                                   #.1.b=r - c1 + c2      ; #.2.b=i - c3 - c4
                 end     /*j*/
               end       /*k*/
             dbl=dbl+dbl
             end         /*p*/
call hdr
         do i=0  for size
         say pad  " FFT  out "   center(i+1,7)  pad  fmt(#.1.i)   fmt(#.2.i,'j')
         end   /*i*/                   /*numbers are shown with 10 digs  [↑]  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
cos: procedure;  parse arg x;  q=r2r(x)**2;   z=1;   _=1;     p=1
     do k=2 by 2; _=-_*q/(k*(k-1)); z=z+_; if z=p then leave; p=z; end; return z
/*────────────────────────────────────────────────────────────────────────────*/
fmt: procedure; parse arg y,j;  y=y/1  /*transforms complex numbers for looks.*/
     if abs(y)<'1e-'digits()%4 then y=0;  if y=0 & j\==''  then return ''
     y=format(y,,10);                     if pos(.,y)\==0  then y=strip(y,'T',0)
     y=strip(y,,.);   if y>=0  then y=' 'y;                return left(y||j, 12)
/*────────────────────────────────────────────────────────────────────────────*/
hdr: _='───data───   num       real─part      imaginary─part';    say pad _
     say pad  translate(_, " "copies('═',256), " "xrange());              return
/*────────────────────────────────────────────────────────────────────────────*/
pi:  return 3.141592653589793238462643383279502884197169399375105820974944592308
/*────────────────────────────────────────────────────────────────────────────*/
r2r: return arg(1) // (pi()*2)         /*reduce the radians to a unit circle. */
