# Project : Horizontal sundial calculations
# Date    : 2017/10/24
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
pi = 22/7
decimals(3)

latitude = -4.95
longitude = -150.5
meridian = -150.0

see "enter latitude (degrees): " + latitude + nl
see "enter longitude (degrees): " + longitude + nl
see "enter legal meridian (degrees): " + meridian + nl

see "time   " + "   sun hour angle" + "      dial hour line angle" + nl

for hour = 6 to 18
    hra = 15*hour - longitude + meridian - 180
    hla = 180/pi*(atan(sin(pi/180*latitude) * tan(pi/180*hra)))
    if fabs(hra) > 90
       hla = hla + 180 * sign(hra * latitude)
    ok
    see "" + hour + "           " + hra + "                  " + hla + nl
next
