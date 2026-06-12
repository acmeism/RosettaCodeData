from turtle import *
from math import *

# Based on C implementation

iter = 3000
diskRatio = .5

factor = .5 + sqrt(1.25)

screen = getscreen()

(winWidth, winHeight) = screen.screensize()

#x = winWidth/2.0

#y = winHeight/2.0

x = 0.0
y = 0.0

maxRad = pow(iter,factor)/iter;

bgcolor("light blue")

hideturtle()

tracer(0, 0)

for i in range(iter+1):
    r = pow(i,factor)/iter;

    if r/maxRad < diskRatio:
        pencolor("black")
    else:
        pencolor("yellow")

    theta = 2*pi*factor*i;

    up()

    setposition(x + r*sin(theta), y + r*cos(theta))

    down()

    circle(10.0 * i/(1.0*iter))

update()

done()
