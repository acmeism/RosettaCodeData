/*REXX program generates and displays a   Mandelbrot set   as an ASCII image. */
xsize = 59;      minre = -2;      maxre = +1;        stepx = (maxre-minre)/xsize
ysize = 21;      minim = -1;      maxim = +1;        stepy = (maxim-minim)/ysize

  do y=0  for ysize;      im=minim+stepy*y
  $=
        do x=0  for xsize
        re=minre+stepx*x;   zr=re;   zi=im

              do n=0  for 30;        a=zr**2;   b=zi**2
              if a+b>4  then leave
              zi=2*zr*zi+im;         zr=a-b+re
              end   /*n*/

        $=$ || d2c(62-n)               /*append number (as a char) to $ string*/
        end         /*x*/
  say $                                /*display a line of character output.  */
  end               /*y*/              /*stick a fork in it,  we're all done. */
