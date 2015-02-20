/*REXX program shows combination sets for  X  things taken  Y  at a time*/
parse arg x y $ .                      /*get optional args from the C.L.*/
if x=='' | x==','  then x=5            /*X  specified?  No, use default.*/
if y=='' | y==','  then y=3            /*Y  specified?  No, use default.*/
@abc='abcdefghijklmnopqrstuvwxyz';   @abcU=@abc;   upper @abcU
if $=='' then $=123456789||@abc||@abcU /*chars for symbol table string. */
say "────────────"        x      ' things taken '      y     " at a time:"
say "────────────"  combN(x,y)   ' combinations.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COMBN subroutine────────────────────*/
combN: procedure expose $;    parse arg x,y;     base=x+1;    bbase=base-y
!.=0;           do i=1  for y;    !.i=i
                end   /*i*/

          do j=1;   L=;           do d=1  for y
                                  L=L  word(substr($,!.d,1)   !.d,1)
                                  end   /*d*/
          say L
          !.y=!.y+1;    if !.y==base   then   if .combUp(y-1)   then leave
          end         /*j*/
return j

.combUp: procedure expose !. y bbase;  parse arg d;  if d==0 then return 1
p=!.d;        do u=d  to y;         !.u=p+1
              if !.u==bbase+u  then return .combUp(u-1)
              p=!.u
              end     /*u*/
return 0
