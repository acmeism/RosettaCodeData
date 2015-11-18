/*REXX program  generates and displays a  Mandelbrot set as a character image.*/
@ = '█▓▒░@9876543210=.-,+*)(·&%$#"!'             /*characters used in display.*/
parse arg Xsize Ysize .                          /*get optional args from C.L.*/
if Xsize==''  then Xsize=linesize()-1            /*X:  the linesize  (less 1).*/
if Ysize==''  then Ysize=Xsize%2 + (Xsize//2==1) /*Y: ½linesize (make it even)*/
minRE = -2;     maxRE = +1;       stepX = (maxRE-minRE) / Xsize
minIM = -1;     maxIM = +1;       stepY = (maxIM-minIM) / Ysize

  do y=0  for ysize;      im=minIM + stepY*y
  $=
        do x=0  for Xsize;   re=minRE + stepX*x;    zr=re;    zi=im

            do n=0  for 30;  a=zr**2;   b=zi**2;    if a+b>4  then leave
            zi=zr*zi*2 + im;            zr=a-b+re
            end   /*n*/

        $=$ || substr(@, n+1, 1)       /*append number (as a char) to $ string*/
        end       /*x*/
  say $                                /*display a line of  character  output.*/
  end             /*y*/                /*stick a fork in it,  we're all done. */
