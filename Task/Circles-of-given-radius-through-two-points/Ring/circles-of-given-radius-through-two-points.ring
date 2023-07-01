# Project : Circles of given radius through two points

decimals(4)
x1 = 0.1234
y1 = 0.9876
x2 = 0.8765
y2 = 0.2345
r = 2.0
see "1 : " + x1 + " " + y1 + " " + x2 + " " + y2 + " " + r + nl
twocircles(x1, y1, x2, y2, r)

x1 = 0.0000
y1 = 2.0000
x2 = 0.0000
y2 = 0.0000
r = 1.0
see "2 : " + x1 + " " + y1 + " " + x2 + " " + y2 + " " + r + nl
twocircles(x1, y1, x2, y2, r)

x1 = 0.1234
y1 = 0.9876
x2 = 0.1234
y2 = 0.9876
r = 2.0
see "3 : " + x1 + " " + y1 + " " + x2 + " " + y2 + " " + r + nl
twocircles(x1, y1, x2, y2, r)

x1 = 0.1234
y1 = 0.9876
x2 = 0.8765
y2 = 0.2345
r = 0.5
see "4 : " + x1 + " " + y1 + " " + x2 + " " + y2 + " " + r + nl
twocircles(x1, y1, x2, y2, r)

x1 = 0.1234
y1 = 0.9876
x2 = 0.1234
y2 = 0.9876
r= 0.0
see "5 : " + x1 + " " + y1 + " " + x2 + " " + y2 + " " + r + nl
twocircles(x1, y1, x2, y2, r)

func twocircles(x1, y1, x2, y2, r)
        if x1=x2 and y1=y2
           if r=0
              see "It will be a single point (" + x1 + "," + y1 + ") of radius 0" + nl + nl
              return
           else
              see "There are any number of circles via single point (" + x1 + "," + y1 + ") of radius " + r + nl + nl
              return
           ok
        ok
        r2 = sqrt(pow((x1-x2),2)+pow((y1-y2),2))/2
        if r<r2
           see "Points are too far apart (" + 2*r2 + ") - there are no circles of radius " + r + nl + nl
           return
        ok
        cx=(x1+x2)/2
        cy=(y1+y2)/2
        dd2=sqrt(pow(r,2)-pow(r2,2))
        dx1=x2-cx
        dy1=y2-cy
        dx = 0-dy1/r2*dd2
        dy = dx1/r2*dd2
        see "(" + (cx+dy) + ", " + (cy+dx) + ")" + nl
        see "(" + (cx-dy) + ", " + (cy-dx) + ")" + nl + nl
