from turtle import *

def rectangle(width, height):
    for _ in range(2):
        forward(height)
        left(90)
        forward(width)
        left(90)

def square(size):
    rectangle(size, size)

def triangle(size):
    for _ in range(3):
        forward(size)
        right(120)

def house(size):
    right(180)
    square(size)
    triangle(size)
    right(180)

def barchart(lst, size):
    scale = size/max(lst)
    width = size/len(lst)
    for i in lst:
        rectangle(i*scale, width)
        penup()
        forward(width)
        pendown()
    penup()
    back(size)
    pendown()

clearscreen()
hideturtle()
house(150)
penup()
forward(10)
pendown()
barchart([0.5, (1/3), 2, 1.3, 0.5], 200)
penup()
back(10)
pendown()
