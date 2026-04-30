-- 21 Feb 2026
include Setting

say 'ARITHMETIC MEAN'
say version
say
call Task '1;2;3;4;5;6;7;8;9;10'
call Task '1;10;100;1000;100000'
call Task '1'
exit

Task:
procedure
arg xx
say 'Arithmetic mean of' List2form(xx) '=' AmeanL(xx)
return

AmeanL:
procedure
arg xx
rr=0; nn=0
do while xx<>''
   parse var xx xw';'xx
   rr+=xw; nn+=1
end
return rr/nn

-- AmeanL full version; List2form
include Math
