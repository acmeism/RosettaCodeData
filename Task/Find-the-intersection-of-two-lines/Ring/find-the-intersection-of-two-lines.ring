# Project : Find the intersection of two lines

xa=4
ya=0
xb=6
yb=10
xc=0
yc=3
xd=10
yd=7
see "the two lines are:" + nl
see "yab=" + (ya-xa*((yb-ya)/(xb-xa))) + "+x*" + ((yb-ya)/(xb-xa)) + nl
see "ycd=" + (yc-xc*((yd-yc)/(xd-xc))) + "+x*" + ((yd-yc)/(xd-xc)) + nl
x=((yc-xc*((yd-yc)/(xd-xc)))-(ya-xa*((yb-ya)/(xb-xa))))/(((yb-ya)/(xb-xa))-((yd-yc)/(xd-xc)))
see "x=" + x + nl
y=ya-xa*((yb-ya)/(xb-xa))+x*((yb-ya)/(xb-xa))
see "yab=" + y + nl
see "ycd=" + (yc-xc*((yd-yc)/(xd-xc))+x*((yd-yc)/(xd-xc))) + nl
see "intersection: " + x + "," + y + nl
