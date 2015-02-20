include std/console.e
include std/mathcons.e

atom lat = prompt_number("Enter Latitude: ",{})
atom lng = prompt_number("Enter Longitude: ",{})
atom lm = prompt_number("Enter Legal Meridian: ",{})
puts(1,'\n')

atom ha, hla

function D2R(atom degrees)
	return degrees * PI / 180
end function

function R2D(atom radians)
	return radians * 180 / PI
end function

function atan2(atom y, atom x)
	return 2*arctan((sqrt(power(x,2)+power(y,2)) - x)/y)
end function

atom s_lat = sin(D2R(lat))

puts(1,"Hour,  Sun Hour Angle, Dial Hour Line Angle\n")

for hour = -6 to 6 do
	ha = hour * 15 - lng + lm
	atom s = sin(D2R(ha))
	atom c = cos(D2R(ha))
	hla = R2D(atan2(s_lat*s,c))
	printf(1,"%3d\t\t\t%7.3f\t\t\t%7.3f\n",{hour+12,ha,hla})
end for

if getc(0) then end if
