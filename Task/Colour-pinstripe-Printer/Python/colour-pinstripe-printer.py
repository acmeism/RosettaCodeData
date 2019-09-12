from turtle import *
from PIL import Image
import time
import subprocess

"""

Only works on Windows. Assumes that you have Ghostscript
installed and in your path.

https://www.ghostscript.com/download/gsdnld.html

Hard coded to 100 pixels per inch.

"""

colors = ["black", "red", "green", "blue", "magenta", "cyan", "yellow", "white"]

screen = getscreen()

# width and height in pixels
# aspect ratio for 11 by 8.5 paper

inch_width = 11.0
inch_height = 8.5

pixels_per_inch = 100

pix_width = int(inch_width*pixels_per_inch)
pix_height = int(inch_height*pixels_per_inch)

screen.setup (width=pix_width, height=pix_height, startx=0, starty=0)

screen.screensize(pix_width,pix_height)

# center is 0,0

# get coordinates of the edges

left_edge = -screen.window_width()//2

right_edge = screen.window_width()//2

bottom_edge = -screen.window_height()//2

top_edge = screen.window_height()//2

# draw quickly

screen.delay(0)
screen.tracer(5)

for inch in range(int(inch_width)-1):
    line_width = inch + 1
    pensize(line_width)
    colornum = 0

    min_x = left_edge + (inch * pixels_per_inch)
    max_x = left_edge + ((inch+1) * pixels_per_inch)

    for y in range(bottom_edge,top_edge,line_width):
        penup()
        pencolor(colors[colornum])
        colornum = (colornum + 1) % len(colors)
        setposition(min_x,y)
        pendown()
        setposition(max_x,y)

screen.getcanvas().postscript(file="striped.eps")

# convert to jpeg
# won't work without Ghostscript.

im = Image.open("striped.eps")
im.save("striped.jpg")

# Got idea from http://rosettacode.org/wiki/Colour_pinstripe/Printer#Go

subprocess.run(["mspaint", "/pt", "striped.jpg"])
