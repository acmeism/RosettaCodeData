/*REXX program to perform the  Cholesky  decomposition on square matrix.*/

niner= '25  15  -5' ,
       '15  18   0' ,
       '-5   0  11'
                            call Cholesky niner
hexer= 18  22  54  42,
       22  70  86  62,
       54  86 174 134,
       42  62 134 106
                            call Cholesky hexer
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────Cholesky subroutine──────────────*/
Cholesky: procedure; arg !; call tell 'input array',!

         do row=1 for order
                do col=1 for row; s=0
                            do i=1 for col-1
                            s=s+$.row.i*$.col.i
                            end   /*i*/
                if row=col then $.row.row=sqrt($.row.row-s)
                           else $.row.col=1/$.col.col*(@.row.col-s)
                end   /*col*/
         end          /*row*/

call tell 'Cholesky factor',,$.,'─'
return
/*─────────────────────────────────────TELL subroutine───&find the order*/
tell:  parse arg hdr,x,y,sep;   #=0;   if sep=='' then sep='═'
decPlaces =  5       /*number of decimal places past the decimal point. */
width     = 10       /*width of field to be used to display the elements*/

if y=='' then    $.=0
         else    do row=1      for order
                       do col=1 for order
                       x=x  $.row.col
                       end   /*row*/
                 end         /*col*/
w=words(x)

     do order=1 until order**2>=w      /*fast way to find the MAT order.*/
     end   /*order*/

if order**2\==w then call err "matrix elements don't match its order"
say;   say center(hdr, ((width+1)*w)%order, sep);   say

        do row=1      for order;     aLine=
             do col=1 for order;     #=#+1
                                @.row.col=word(x,#)
             if col<=row  then  $.row.col=@.row.col
             aLine=aLine  right( format(@.row.col,, decPlaces) /1, width)
             end   /*col*/
        say aLine
        end        /*row*/
return
/*─────────────────────────────────────SQRT subroutine──────────────────*/
sqrt: procedure;   parse arg x;   if x=0 then return 0;   d=digits()
  numeric digits 11; g=.sqrtGuess(); do j=0 while p>9; m.j=p; p=p%2+1; end
    do k=j+5 to 0 by -1;if m.k>11 then numeric digits m.k;g=.5*(g+x/g);end
  numeric digits d;   return g/1

.sqrtGuess: if x<0  then call err 'SQRT of negative #';    numeric form
        m.=11; p=d+d%4+2; parse value format(x,2,1,,0) 'E0' with g 'E' _ .
        return g*.5'E'_%2
/*─────────────────────────────────────ERR subroutine───────────────────*/
err:  say; say;  say '***error***!';  say;  say arg(1);  say; say; exit 13
