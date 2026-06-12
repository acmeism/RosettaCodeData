#!/usr/bin/python3

import tkinter as tk
from math import cos, sin

WIDTH, HEIGHT = 800, 800
cx, cy = WIDTH // 2, HEIGHT // 2

# name, distance, speed, size, angle, color
planets = [
    ["Moon",     70,  0.01,  6, 0, "#C8C8C8"],
    ["Mercury", 120,  0.008, 5, 0, "#969696"],
    ["Venus",   170,  0.006, 9, 0, "#FFC800"],
    ["Sun",     230,  0.004,18, 0, "#FF9600"],
    ["Mars",    300,  0.003, 7, 0, "#FF3200"],
    ["Jupiter", 360,  0.002,15, 0, "#C89664"]
]

root = tk.Tk()
root.title("Geocentric model - Python + Tkinter")

canvas = tk.Canvas(root, width=WIDTH, height=HEIGHT, bg="#050514")
canvas.pack()

def draw():
    canvas.delete("all")

    # orbits + planets
    for p in planets:
        name, dist, speed, size, angle, color = p

        # update angle
        angle += speed
        p[4] = angle

        # orbits
        canvas.create_oval(cx-dist, cy-dist, cx+dist, cy+dist,
                           outline="#3C3C3C")

        # planet's position
        px = cx + cos(angle) * dist
        py = cy + sin(angle) * dist

        # planets
        canvas.create_oval(px-size, py-size, px+size, py+size,
                           fill=color, outline=color)

        # label (slightly offset)
        canvas.create_text(px + size + 8, py, text=name,
                           fill="white", anchor="w", font=("Arial", 10))


    root.after(16, draw)

draw()
root.mainloop()
