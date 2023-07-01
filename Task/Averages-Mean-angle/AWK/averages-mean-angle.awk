#!/usr/bin/awk -f
{
    PI = atan2(0,-1);
    x=0.0; y=0.0;
    for (i=1; i<=NF; i++) {	
	p = $i*PI/180.0;
	x += sin(p);
	y += cos(p);
    }
    p = atan2(x,y)*180.0/PI;	
    if (p<0) p += 360;
    print p;
}
