# syntax: GAWK -f LENGTH_OF_AN_ARC_BETWEEN_TWO_ANGLES.AWK
# converted from PHIX
BEGIN {
    printf("%.7f\n",arc_length(10,10,120))
    exit(0)
}
function arc_length(radius,angle1,angle2) {
    return (360 - abs(angle2-angle1)) * 3.14159265 / 180 * radius
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
