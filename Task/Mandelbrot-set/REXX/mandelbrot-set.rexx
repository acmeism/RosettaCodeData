/*REXX program generates and displays a Mandelbrot set as an ASCII image*/
xsize = 59;     minre = -2;    maxre = +1;     stepx = (maxre-minre)/xsize
ysize = 21;     minim = -1;    maxim = +1;     stepy = (maxim-minim)/ysize

  do y=0  for ysize
  im=minim+stepy*y
      do x=0  for xsize
      re=minre+stepx*x;  zr=re;  zi=im
            do n=0  for 30
            a=zr*zr;  b=zi*zi
            if a+b>4  then leave
            zi=2*zr*zi+im;  zr=a-b+re
            end   /*n*/
      call charout ,d2c(62-n)          /*display number as a char──►term*/
      end         /*x*/
  say                                  /*force last CHAROUTs to the term*/
  end             /*y*/                /*stick a fork in it, we're done.*/
