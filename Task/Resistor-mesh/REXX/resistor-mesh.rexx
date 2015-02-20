/*REXX pgm calculates resistance between any 2 points on a resister grid*/
numeric digits 20                      /*use moderate digits (precision)*/
minVal = (1'e-' || (digits()*2))  / 1  /*calculate the threshold min val*/
if 1=='f1'x  then ohms = 'ohms'        /*EBCDIC machine?    Use 'ohms'. */
             else ohms = 'ea'x         /* ASCII machine?    Use Greek Ω.*/
parse arg   high wide   Arow Acol   Brow Bcol   .
say 'minVal = '    format(minVal,,,,0)                             ;   say
say 'resistor mesh is of size: '  wide  "wide, "   high   'high.'  ;   say
say 'point A is at (row,col): '   Arow","Acol
say 'point B is at (row,col): '   Brow","Bcol
@.=0; cell.=1
               do  until  $ <= minVal;    $=0;         v = 0
               @.Arow.Acol = +1 ;         cell.Arow.Acol = 0
               @.Brow.Bcol = -1 ;         cell.Brow.Bcol = 0

                  do   i=1  for high;     im=i-1;       ip=i+1
                    do j=1  for wide;     jm=j-1;       jp=j+1;  n=0;  v=0
                    if i\==1   then do;   v=v+@.im.j;   n=n+1;   end
                    if j\==1   then do;   v=v+@.i.jm;   n=n+1;   end
                    if i<high  then do;   v=v+@.ip.j;   n=n+1;   end
                    if j<wide  then do;   v=v+@.i.jp;   n=n+1;   end
                    v=@.i.j-v/n;   #.i.j=v;    if cell.i.j  then $=$+v*v
                    end   /*j*/
                  end     /*i*/
                                do   r=1  for High
                                  do c=1  for Wide;  @.r.c = @.r.c - #.r.c
                                  end   /*c*/
                                end     /*r*/
               end   /*until*/
say
Acur = #.Arow.Acol * sides(Arow,Acol)
Bcur = #.Brow.Bcol * sides(Brow,Bcol)
say 'resistance between point A and point B is: '    4/(Acur-Bcur)    ohms
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────sides subroutine────────────────────*/
sides:  parse arg i,j;    !=0;     if i\==1 & i\==high  then  !=!+2
                                                        else  !=!+1
                                   if j\==1 & j\==wide  then  !=!+2
                                                        else  !=!+1
return !
