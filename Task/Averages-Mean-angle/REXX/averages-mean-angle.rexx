-- 21 Feb 2026
include Setting

say 'MEAN ANGLE'
say version
say
numeric digits 11
say 'Meaningful...'
call Task '350;10'
call Task '10;20;30'
call Task '180'
say
say 'Mathematically undefined...'
call Task '90;180;270;360'
call Task '0;180'
call Task '45;225'
call Task '90;270'
call Task '135;305'
exit

Task:
procedure expose Memo.
arg xx
say 'Mean angle of list {'xx'} =' DegL(CmeanL(RadL(xx)))/1
return

CmeanL:
-- Returns circular mean of a list
procedure expose Memo.
arg xx
ss=0; sc=0
do while xx<>''
   parse var xx xw';'xx
   ss+=Sin(xw); sc+=Cos(xw)
end
return Arctan2(sc,ss)

-- CmeanL (full); DegL; RadL; Sin; Cos; Arctan2
include Math
