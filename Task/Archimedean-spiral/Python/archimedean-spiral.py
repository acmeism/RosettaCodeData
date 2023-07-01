from turtle import *
from math import *
color("blue")
down()
for i in range(200):
    t = i / 20 * pi
    x = (1 + 5 * t) * cos(t)
    y = (1 + 5 * t) * sin(t)
    goto(x, y)
up()
done()
