include std/console.e
include std/mathcons.e

sequence AngleList = {{350,10},{90,180,270,360},{10,20,30}}

function atan2(atom y, atom x)
	return 2*arctan((sqrt(power(x,2)+power(y,2)) - x)/y)
end function

function MeanAngle(sequence angles)
	atom x = 0, y = 0
	integer l = length(angles)
	
	for i = 1 to length(angles) do
		x += cos(angles[i] * PI / 180)
		y += sin(angles[i] * PI / 180)
	end for
	
	return atan2(y / l, x / l) * 180 / PI
end function

for i = 1 to length(AngleList) do
	printf(1,"Mean Angle for set %d:  %3.5f\n",{i,MeanAngle(AngleList[i])})
end for

if getc(0) then end if
