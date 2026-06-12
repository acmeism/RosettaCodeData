#!/usr/bin/python3

import tkinter as tk
import math

def drawMoebius(canvas):
    cX = 300
    cY = 300
    radius = 150.0
    halfWidth = 60.0
    k = 0.3

    for u in range(0, 360, 2):
        radU = math.radians(u)

        # Inner edge point
        v1 = -halfWidth
        x1 = (radius + v1 * math.cos(radU / 2)) * math.cos(radU)
        y1 = (radius + v1 * math.cos(radU / 2)) * math.sin(radU)
        z1 = v1 * math.sin(radU / 2)
        px1 = cX + x1 + (z1 * k)
        py1 = cY + y1 - (z1 * k)

        # Outer edge point
        v2 = halfWidth
        x2 = (radius + v2 * math.cos(radU / 2)) * math.cos(radU)
        y2 = (radius + v2 * math.cos(radU / 2)) * math.sin(radU)
        z2 = v2 * math.sin(radU / 2)
        px2 = cX + x2 + (z2 * k)
        py2 = cY + y2 - (z2 * k)

        # Draw a red line between the two edges
        canvas.create_line(px1, py1, px2, py2, fill="red")

# Create Tkinter window
root = tk.Tk()
root.title("Möbius strip - Tkinter")

canvas = tk.Canvas(root, width=600, height=600, bg="black")
canvas.pack()

drawMoebius(canvas)

root.mainloop()
