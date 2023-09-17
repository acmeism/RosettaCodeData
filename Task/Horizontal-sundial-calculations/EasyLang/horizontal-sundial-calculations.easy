func getn s$ .
   write s$
   v = number input
   print v
   return v
.
lat = getn "Enter latitude: "
lng = getn "Enter longitude: "
merid = getn "Enter legal meridian: "
slat = sin lat
diff = lng - merid
print ""
print "    sine of latitude: " & slat
print "    diff longitude: " & diff
print ""
print "Hour\tSun hour angle\tDial hour line angle"
for h = -6 to 6
   hra = 15 * h - diff
   hla = atan2 (slat * sin hra) cos hra
   print h + 12 & "\t" & hra & "\t\t" & hla
.
