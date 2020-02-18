/*REXX program displays   combination sets   for   X   things taken   Y   at a time.    */
parse arg x y $ .                                /*get optional arguments from the C.L. */
if x=='' | x==","  then x=5                      /*No  X  specified?   Then use default.*/
if y=='' | y==","  then y=3;  oy= y;  y= abs(y)  /* "  Y      "          "   "     "    */
if $=='' | $==","  then $='123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
                          "~!@#$%^&*()_+`{}|[]\:;<>?,./█┌┐└┘±≥≤≈∙" /*some extended chars*/
                                                 /* [↑]  No  $  specified?  Use default.*/
if y>x             then do;  say y  " can't be greater than "  x;      exit 1;    end
say "────────────"             x            ' things taken '        y        " at a time:"
say "────────────"       combN(x,y)         ' combinations.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
combN:  procedure expose $ oy;  parse arg x,y;      xp= x+1;       xm= xp-y;         !.= 0
                                                    if x=0 | y=0   then return 'no'
                                do i=1  for y;      !.i= i
                                end   /*i*/
                  do j=1;  L=
                                do d=1  for y;      L= L substr($, !.d, 1)
                                end   /*d*/
                  if oy>0  then say L;              !.y= !.y+1     /*don't show if OY<0 */
                  if !.y==xp  then  if .combN(y-1)  then leave
                  end   /*j*/
        return j
/*──────────────────────────────────────────────────────────────────────────────────────*/
.combN: procedure expose !. y xm;  parse arg d;  if d==0  then return 1;            p= !.d
                  do u=d  to y;  !.u= p+1;  if !.u==xm+u  then return .combN(u-1);  p= !.u
                  end   /*u*/                    /*                       ↑             */
        return 0                                 /*recursive call──►──────┘             */
