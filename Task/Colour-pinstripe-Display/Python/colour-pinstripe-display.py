from turtle import *

colors = ["black", "red", "green", "blue", "magenta", "cyan", "yellow", "white"]

# Middle of screen is 0,0

screen = getscreen()

left_edge = -screen.window_width()//2

right_edge = screen.window_width()//2

quarter_height = screen.window_height()//4

half_height = quarter_height * 2

speed("fastest")

for quarter in range(4):
    pensize(quarter+1)
    colornum = 0

    min_y = half_height - ((quarter + 1) * quarter_height)
    max_y = half_height - ((quarter) * quarter_height)

    for x in range(left_edge,right_edge,quarter+1):
        penup()
        pencolor(colors[colornum])
        colornum = (colornum + 1) % len(colors)
        setposition(x,min_y)
        pendown()
        setposition(x,max_y)

notused = input("Hit enter to continue: ")
