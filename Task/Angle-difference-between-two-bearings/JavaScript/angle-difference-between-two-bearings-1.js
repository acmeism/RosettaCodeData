function relativeBearing(b1Rad, b2Rad)
{
	b1y = Math.cos(b1Rad);
	b1x = Math.sin(b1Rad);
	b2y = Math.cos(b2Rad);
	b2x = Math.sin(b2Rad);
	crossp = b1y * b2x - b2y * b1x;
	dotp = b1x * b2x + b1y * b2y;
	if(crossp > 0.)
		return Math.acos(dotp);
	return -Math.acos(dotp);
}

function test()
{
	var deg2rad = 3.14159265/180.0;
	var rad2deg = 180.0/3.14159265;
	return "Input in -180 to +180 range\n"
		+relativeBearing(20.0*deg2rad, 45.0*deg2rad)*rad2deg+"\n"
		+relativeBearing(-45.0*deg2rad, 45.0*deg2rad)*rad2deg+"\n"
		+relativeBearing(-85.0*deg2rad, 90.0*deg2rad)*rad2deg+"\n"
		+relativeBearing(-95.0*deg2rad, 90.0*deg2rad)*rad2deg+"\n"
		+relativeBearing(-45.0*deg2rad, 125.0*deg2rad)*rad2deg+"\n"
		+relativeBearing(-45.0*deg2rad, 145.0*deg2rad)*rad2deg+"\n"

		+relativeBearing(29.4803*deg2rad, -88.6381*deg2rad)*rad2deg+"\n"
		+relativeBearing(-78.3251*deg2rad, -159.036*deg2rad)*rad2deg+"\n"
	
		+ "Input in wider range\n"
		+relativeBearing(-70099.74233810938*deg2rad, 29840.67437876723*deg2rad)*rad2deg+"\n"
		+relativeBearing(-165313.6666297357*deg2rad, 33693.9894517456*deg2rad)*rad2deg+"\n"
		+relativeBearing(1174.8380510598456*deg2rad, -154146.66490124757*deg2rad)*rad2deg+"\n"
		+relativeBearing(60175.77306795546*deg2rad, 42213.07192354373*deg2rad)*rad2deg+"\n";

}
