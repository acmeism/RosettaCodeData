decimals(7)
pi = 3.14159265

see "Length of an arc between two angles:" + nl
see arcLength(10,10,120) + nl

func arcLength(radius,angle1,angle2)
     x = (360 - fabs(angle2-angle1)) * pi / 180 * radius
     return x
