-- 26 Jun 2026
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
procedure
arg xx
say 'Mean angle of list {'xx'} =' Round(DegL(CmeanL(RadL(xx)))/1)
return

CmeanL:
-- Circular mean number list
procedure
arg xx
numeric digits Digits()+1
rs=0; rc=0
do while xx<>''
   parse var xx xs';'xx
   rs+=Sin(xs); rc+=Cos(xs)
end
rr=Arctan2(rs,rc)
if rr<0 then
   rr+=Twopi()
return rr

-- DegL RadL Sin Cos Arctan2 Twopi
include Math
