/*REXX pgm does a fast Fourier transform (FFT) on a set of complex nums.*/
numeric digits 85
arg data; if data='' then data='1 1 1 1 0'  /*no data?  Then use default*/
data=translate(data, 'J', "I")         /*allow use of  i  as well as  j */
size=words(data);    pad=left('',6)    /*PAD: for indenting/padding SAYs*/
  do sig=0 until 2**sig>=size      ;end /* #  args exactly a power of 2?*/
  do j=size+1 to 2**sig;data=data 0;end /*add zeroes until a power of 2.*/
size=words(data);    call hdr          /*┌─────────────────────────────┐*/
                                       /*│ Numbers in  data  can be in │*/
  do j=0  for size                     /*│ 7 formats:   real           │*/
  _=word(data,j+1)                     /*│              real,imag      │*/
  parse var  _  #.1.j  ','  #.2.j      /*│                  ,imag      │*/
  if right(#.1.j,1)=='J'    then       /*│                   nnnJ      │*/
      parse var #.1.j #2.j "J" @.1.j   /*│                   nnnj      │*/
    do p=1  for 2     /*omitted?*/     /*│                   nnnI      │*/
    #.p.j=word(#.p.j 0, 1)             /*│                   nnni      │*/
    end   /*p*/                        /*└─────────────────────────────┘*/
  say pad " FFT   in "    center(j+1,7)  pad  nice(#.1.j)  nice(#.2.j,'i')
  end     /*j*/

say;             say;                       tran=2*pi()/2**sig;  !.=0
hsig=2**sig%2;   counterA=2**(sig-sig%2);   pointer=counterA;    doubler=1

  do sig-sig%2;  halfpointer=pointer%2
            do i=halfpointer  by pointer  to counterA-halfpointer
            _=i-halfpointer;  !.i=!._+doubler
            end   /*i*/
  doubler=doubler*2;  pointer=halfpointer
  end   /*sig-sig%2*/

         do j=0 to 2**sig%4; cmp.j=cos(j*tran);  _m=hsig-j;  cmp._m=-cmp.j
                                                 _p=hsig+j;  cmp._p=-cmp.j
         end  /*j*/

counterB=2**(sig%2)

  do i=0  for counterA;    p=i*counterB
      do j=0 for counterB; h=p+j; _=!.j*counterB+!.i; if _<=h then iterate
      parse value  #.1._ #.1.h #.2._ #.2.h   with  #.1.h #.1._ #.2.h #.2._
      end   /*j*/                      /* [↓]  switch two sets of values*/
  end       /*i*/

double=1;       do sig               ;  w=2**sig%2%double
                  do k=0  for double ;  lb=w*k           ; lh=lb+2**sig%4
                    do j=0 for w     ;  a=j*double*2+k   ; b=a+double
                    r=#.1.a; i=#.2.a ;  c1=cmp.lb*#.1.b  ; c4=cmp.lb*#.2.b
                                        c2=cmp.lh*#.2.b  ; c3=cmp.lh*#.1.b
                                        #.1.a=r+c1-c2    ; #.2.a=i+c3+c4
                                        #.1.b=r-c1+c2    ; #.2.b=i-c3-c4
                    end              /*j*/
                  end                /*k*/
                double=double+double
                end                  /*sig*/
call hdr
        do i=0  for size
        say pad " FFT  out " center(i+1,7) pad nice(#.1.i) nice(#.2.i,'j')
        end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HDR subroutine──────────────────────*/
hdr:  _='───data───   num       real-part      imaginary-part';  say pad _
      say pad  translate(_, " "copies('═',256), " "xrange());    return
/*──────────────────────────────────PI subroutine───────────────────────────────────*/
pi: return ,                           /*add more digs   if   NUMERIC DIGITS > 85.  */
3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628
/*──────────────────────────────────R2R subroutine──────────────────────*/
r2r:  return arg(1) // (2*pi())        /*reduce radians to unit circle. */
/*──────────────────────────────────COS subroutine──────────────────────*/
cos:  procedure;   parse arg x;    x=r2r(x);     return .sincos(1,1,-1)
.sincos: parse arg z,_,i;   x=x*x;   p=z
         do k=2 by 2; _=-_*x/(k*(k+i)); z=z+_; if z=p then leave; p=z; end
         return z
/*──────────────────────────────────NICE subroutine─────────────────────*/
nice: procedure; parse arg x,j         /*makes complex nums look nicer. */
numeric digits digits()%10;   nz='1e-'digits()    /*show ≈10% of DIGITS.*/
if abs(x)<nz  then x=0;       x=x/1;       if x=0 & j\==''  then return ''
x=format(x,,digits());        if pos('.',x)\==0  then x=strip(x,'T',0)
x=strip(x,,'.');     if x>=0  then x=' '||x;  return left(x||j,digits()+4)
