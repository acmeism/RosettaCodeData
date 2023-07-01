# syntax: GAWK -f CIRCLES_OF_GIVEN_RADIUS_THROUGH_TWO_POINTS.AWK
# converted from PL/I
BEGIN {
    split("0.1234,0,0.1234,0.1234,0.1234",m1x,",")
    split("0.9876,2,0.9876,0.9876,0.9876",m1y,",")
    split("0.8765,0,0.1234,0.8765,0.1234",m2x,",")
    split("0.2345,0,0.9876,0.2345,0.9876",m2y,",")
    leng = split("2,1,2,0.5,0",r,",")
    print("     x1      y1      x2      y2    r   cir1x   cir1y   cir2x   cir2y")
    print("------- ------- ------- ------- ---- ------- ------- ------- -------")
    for (i=1; i<=leng; i++) {
      printf("%7.4f %7.4f %7.4f %7.4f %4.2f %s\n",m1x[i],m1y[i],m2x[i],m2y[i],r[i],main(m1x[i],m1y[i],m2x[i],m2y[i],r[i]))
    }
    exit(0)
}
function main(m1x,m1y,m2x,m2y,r,  bx,by,pb,x,x1,y,y1) {
    if (r == 0) { return("radius of zero gives no circles") }
    x = (m2x - m1x) / 2
    y = (m2y - m1y) / 2
    bx = m1x + x
    by = m1y + y
    pb = sqrt(x^2 + y^2)
    if (pb == 0) { return("coincident points give infinite circles") }
    if (pb > r) { return("points are too far apart for the given radius") }
    cb = sqrt(r^2 - pb^2)
    x1 = y * cb / pb
    y1 = x * cb / pb
    return(sprintf("%7.4f %7.4f %7.4f %7.4f",bx-x1,by+y1,bx+x1,by-y1))
}
