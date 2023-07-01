from __future__ import print_function, division
from visual import *

title = "VPython: Draw a sphere"
scene.title = title
print( "%s\n" % title )

print( 'Drag with right mousebutton to rotate view'  )
print( 'Drag up+down with middle mousebutton to zoom')

scene.autocenter = True

# uncomment any (or all) of those variants:
S1 = sphere(pos=(0.0, 0.0, 0.0), radius=1.0, color=color.blue)
#S2 = sphere(pos=(2.0, 0.0, 0.0), radius=1.0, material=materials.earth)
#S3 = sphere(pos=(0.0, 2.0, 0.0), radius=1.0, material=materials.BlueMarble)
#S4 = sphere(pos=(0.0, 0.0, 2.0), radius=1.0,
#            color=color.orange, material=materials.marble)

while True:                 # Animation-loop
    rate(100)
    pass                    # no animation in this demo
