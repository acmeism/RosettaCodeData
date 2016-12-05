/*REXX program displays   combination sets   for   X   things taken   Y   at a time.    */
parse arg x y $ .                                /*get optional arguments from the C.L. */
if x=='' | x==","  then x=5                      /*No  X  specified?   Then use default.*/
if y=='' | y==","  then y=3                      /* "  Y      "          "   "     "    */
if $=='' | $==","  then $= '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
                                                 /* [↑]  No  $  specified?  Use default.*/
say "────────────"             x            ' things taken '        y        " at a time:"
say "────────────"       combN(x,y)         ' combinations.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
combN:  procedure expose $;   parse arg x,y;     xp=x+1;    xm=xp-y;   !.=0
                                do i=1  for y; !.i=i;                            end /*i*/
                  do j=1;  L=;  do d=1  for y; L=L word(substr($,!.d,1) !.d, 1); end /*d*/
                  say L;      !.y=!.y+1
                  if !.y==xp  then  if .combN(y-1)  then leave
                  end   /*j*/
        return j
.combN: procedure expose !. y xm;  parse arg d;  if d==0  then return 1;             p=!.d
                  do u=d  to y;  !.u=p+1;   if !.u==xm+u  then return .combN(u-1);   p=!.u
                  end   /*u*/
        return 0
