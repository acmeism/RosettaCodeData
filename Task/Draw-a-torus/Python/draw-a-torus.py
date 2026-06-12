#!/usr/bin/python3

import tkinter as tk
import math

# Create window
root = tk.Tk()
root.title("Torus - Tkinter")

w, h = 800, 600

canvas = tk.Canvas(root, width=w, height=h)
canvas.pack()

img = tk.PhotoImage(width=w, height=h)
canvas.create_image((0, 0), image=img, wr="nw")

bg = "#0A0A0F"
for y in range(h):
    img.put(bg, to=(0, y, w, y+1))

Rext = 150  # outer radius
Rint = 60   # inner radius (tube radius)

# Rotation angles (in radians)
A = 0.5
B = 0.5

sinA = math.sin(A)
cosA = math.cos(A)
sinB = math.sin(B)
cosB = math.cos(B)

for jj in range(0, 629):  # Rotation angles (in radians)
    j = jj / 100
    ii = 0
    while ii < 628:  # tube circumference (phi)
        i = ii / 100

        sini = math.sin(i)
        cosi = math.cos(i)
        sinj = math.sin(j)
        cosj = math.cos(j)

        # 3D coordinate calculation
        h = Rext + Rint * cosj

        x = h * (cosB * cosi + sinA * sinB * sini) - Rint * cosA * sinB * sinj
        y = h * (sinB * cosi - sinA * cosB * sini) + Rint * cosA * cosB * sinj
        z = h * cosA * sini + Rint * sinA * sinj

        # Luminance calculation
        tmp = cosj * cosi * sinB - sinA * cosj * sini * cosB - cosA * sinj * cosB
        lum = 8 * (tmp - cosi * sinj * sinA)

        if lum > 0:
            # Set color based on brightness (0-255)
            bright = int(lum * 30)
            if bright > 255:
                bright = 255

            r = bright // 2
            g = bright
            b = 255

            color = f"#{r:02x}{g:02x}{b:02x}"

            # Perspective projection to 2D
            ooz = 1 / (z + 500)
            xp = int(400 + x * ooz * 600)
            yp = int(300 - y * ooz * 600)

            if 0 <= xp < w and 0 <= yp < h:
                img.put(color, (xp, yp))

        ii += 4

root.mainloop()
