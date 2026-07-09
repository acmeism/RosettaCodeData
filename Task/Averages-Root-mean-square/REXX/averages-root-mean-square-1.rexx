-- 7 Jul 2026
include Setting

say 'ROOT MEAN SQUARE'
say version
say
call Task '1 2 3 4 5 6 7 8 9 10'
call Task '1 10 100 1000 100000'
call Task '1'
exit

Task:
procedure
arg xx
say 'RMS of' Vect2form(xx) '=' Qmean(xx)
return

Qmean:
procedure
arg xx
rr=0; nn=Words(xx)
do w=1 to nn
   xw=Word(xx,w); rr+=xw*xw
end
return Sqrt(rr/nn)

-- Sqrt
include Math
