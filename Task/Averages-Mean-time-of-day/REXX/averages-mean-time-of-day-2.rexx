-- 26 Jun 2026
include Setting

say 'MEAN TIME OF DAY'
say version
say
say Angle2time(CmeanL(MapL('23:00:17;23:40:20;00:12:45;00:17:19','Time2angle(x)')))
exit

Time2angle:
procedure
arg xx
parse value Timesplit(xx) with xh xm xs xd
return Twopi()*(xh*36E5+xm*6E4+xs*1E3+xd)/864E5

Angle2time:
procedure
arg xx
xx=Round(xx*864E5/Twopi())
xh=xx%36E5; xx=xx//36E5; xm=xx%6E4; xx=xx//6E4; xs=xx%1E3; xx=xx//1E3; xd=xx
return xh':'xm':'xs'.'xd

CmeanL:
procedure
arg xx
rs=0; rc=0
do while xx<>''
   parse var xx xs';'xx
   rs+=Sin(xs); rc+=Cos(xs)
end
at=Arctan2(rs,rc)
if at<0 then
   at+=Twopi()
return at

-- MapL Timesplit Round Twopi Sin Cos Arctan2
include Math
