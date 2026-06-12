import turtle
from itertools import cycle
from time import sleep

def rect(t, x, y):
    x2, y2 = x/2, y/2
    t.setpos(-x2, -y2)
    t.pendown()
    for pos in [(-x2, y2), (x2, y2), (x2, -y2), (-x2, -y2)]:
        t.goto(pos)
    t.penup()

def rects(t, colour, wait_between_rect=0.1):
    for x in range(550, 0, -25):
        t.color(colour)
        rect(t, x, x*.75)
        sleep(wait_between_rect)

tl=turtle.Turtle()
screen=turtle.Screen()
screen.setup(620,620)
screen.bgcolor('black')
screen.title('Rosetta Code Vibrating Rectangles')
tl.pensize(3)
tl.speed(0)
tl.penup()
tl.ht()
colours = 'red green blue orange white yellow'.split()
for colour in cycle(colours):
    rects(tl, colour)
    sleep(0.5)
