# syntax: GAWK -f FIND_THE_INTERSECTION_OF_TWO_LINES.AWK
# converted from Ring
BEGIN {
    intersect(4,0,6,10,0,3,10,7)
    exit(0)
}
function intersect(xa,ya,xb,yb,xc,yc,xd,yd,  errors,x,y) {
    printf("the 1st line passes through (%g,%g) and (%g,%g)\n",xa,ya,xb,yb)
    printf("the 2nd line passes through (%g,%g) and (%g,%g)\n",xc,yc,xd,yd)
    if (xb-xa == 0) { print("error: xb-xa=0") ; errors++ }
    if (xd-xc == 0) { print("error: xd-xc=0") ; errors++ }
    if (errors > 0) {
      print("")
      return(0)
    }
    printf("the two lines are:\n")
    printf("yab=%g+x*%g\n",ya-xa*((yb-ya)/(xb-xa)),(yb-ya)/(xb-xa))
    printf("ycd=%g+x*%g\n",yc-xc*((yd-yc)/(xd-xc)),(yd-yc)/(xd-xc))
    x = ((yc-xc*((yd-yc)/(xd-xc)))-(ya-xa*((yb-ya)/(xb-xa))))/(((yb-ya)/(xb-xa))-((yd-yc)/(xd-xc)))
    printf("x=%g\n",x)
    y = ya-xa*((yb-ya)/(xb-xa))+x*((yb-ya)/(xb-xa))
    printf("yab=%g\n",y)
    printf("ycd=%g\n",yc-xc*((yd-yc)/(xd-xc))+x*((yd-yc)/(xd-xc)))
    printf("intersection: %g,%g\n\n",x,y)
    return(1)
}
