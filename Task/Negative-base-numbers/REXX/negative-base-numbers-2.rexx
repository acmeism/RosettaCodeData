/*REXX pgm converts & displays a base ten integer to a negative base number (up to -71).*/
@=' converted to base ';      numeric digits 300 /*be able to handle ginormous numbers. */
n=      10;  b=  -2;   q= nBase(n, b);   say right(n, 20)  @  right(b,3)  '────►'  q  ok()
n=     146;  b=  -3;   q= nBase(n, b);   say right(n, 20)  @  right(b,3)  '────►'  q  ok()
n=      15;  b= -10;   q= nBase(n, b);   say right(n, 20)  @  right(b,3)  '────►'  q  ok()
n=     -15;  b= -10;   q= nBase(n, b);   say right(n, 20)  @  right(b,3)  '────►'  q  ok()
n=       0;  b=  -5;   q= nBase(n, b);   say right(n, 20)  @  right(b,3)  '────►'  q  ok()
n=-6284695;  b= -62;   q= nBase(n, b);   say right(n, 20)  @  right(b,3)  '────►'  q  ok()
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
_Base: !='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz /*+-!éáµ' /*sym*/
       parse arg $;        m= length(!);           L= length(x);             p= 0
       if r<-m | r>-2 then do;  say 'base' r "must be in range: -2 ───► -"m; exit 13;  end
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
nBase: procedure; parse arg x,r;   call _Base    /*get args; $  will be integer result. */
                    do  while x\==0              /*keep processing while  X  isn't zero.*/
                    z=x // r;         x= x % r   /*calculate remainder; calculate int ÷.*/
                    if z<0  then do;  z= z - r   /*subtract a negative  R  from  Z ◄──┐ */
                                      x= x + 1   /*bump  X  by one.                   │ */
                                 end             /*                   Funny "add" ►───┘ */
                    $=substr(!, z+1, 1)$         /*prepend the new numeral to the result*/
                    end   /*while*/
       if $==''  then return 0;    return $      /*possibly adjust for a  zero  value.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ok:    if pBase(q, b)\=n  then return ' ◄──error in negative base calculation';  return ''
/*──────────────────────────────────────────────────────────────────────────────────────*/
pBase: procedure; parse arg x,r;   call _Base 0  /*get args; $  will be integer result. */
                    do j=L  by -1  for L         /*process each of the numerals in  X.  */
                    v=pos( substr(x,j,1), !) - 1 /*use base  R  for the numeral's value.*/
                    $= $ + v * r**p;    p= p + 1 /*add it to $ (result); bump power by 1*/
                    end   /*j*/                  /* [↑]  process the number "bottom-up".*/
       return $
