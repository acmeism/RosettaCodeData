/*REXX program shows combination sets for  X  things taken  Y  at a time*/
parse arg x y symbols .;  if x=='' | x==',' then x=3
                          if y=='' | y==',' then y=2
if symbols=='' then symbols='iced jam plain'       /*symbol table words.*/

say "────────────" abs(x) 'doughnut selection taken' y "at a time:"
say "────────────" RcombN(x,y) 'combinations.';      if x\=='' then exit #
say
    x= -10          /*indicate that the combinations aren't to be shown.*/
    y=   3
say "────────────" abs(x) 'doughnut selection choose' y "at a time:"
say "────────────" RcombN(x,y) 'combinations.'
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────RCOMBN subroutine────────────────*/
RcombN: procedure expose # symbols; parse arg x 1 ox,y;  x=abs(x);  base=x
!.=1
           do #=1;  if ox>0 then do;  L=;     do d=1 for y while ox>0
                                              L=L word(symbols,!.d)
                                              end   /*d*/ ;          say L
                                 end
           !.y=!.y+1;    if !.y==base then if .RcombN(y-1) then leave
           end    /*#*/
return #
/*─────────────────────────────────────.RCOMBN subroutine───────────────*/
.RcombN: procedure expose !. y base;   parse arg d;  if d==0 then return 1
p=!.d+1;   if p==base then return .RcombN(d-1)
                do u=d to y
                !.u=p
                end     /*u*/
return 0
