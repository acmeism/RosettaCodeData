# HelloWorld for VPython - HaJo Gurt - 2014-09-20
from visual import *

scene.title = "VPython Demo"
scene.background = color.gray(0.2)

scene.width  = 600
scene.height = 400
scene.range  = 4
#scene.autocenter = True

S = sphere(pos=(0,0,0), radius=1, material=materials.earth)
rot=0.005

txPos=(0, 1.2, 0)

from visual.text import *
# Old 3D text machinery (pre-Visual 5.3): numbers and uppercase letters only:
T1 = text(pos=txPos, string='HELLO', color=color.red, depth=0.3, justify='center')

import vis
# new text object, can render text from any font (default: "sans") :
T2 = vis.text(pos=txPos, text="Goodbye", color=color.green, depth=-0.3, align='center')
T2.visible=False

Lbl_w = label(pos=(0,0,0), text='World', color=color.cyan,
              xoffset=80, yoffset=-40)     # in screen-pixels

L1 = label(pos=(0,-1.5,0), text='Drag with right mousebutton to rotate view',   box=0)
L2 = label(pos=(0,-1.9,0), text='Drag up+down with middle mousebutton to zoom', box=0)
L3 = label(pos=(0,-2.3,0), text='Left-click to change', color=color.orange,     box=0)

print "Hello World"     # Console


cCount = 0
def change():
    global rot, cCount
    cCount=cCount+1
    print "change:", cCount
    rot=-rot
    if T1.visible:
        T1.visible=False
        T2.visible=True
    else:
        T1.visible=True
        T2.visible=False

scene.bind( 'click', change )

while True:
  rate(100)
  S.rotate( angle=rot, axis=(0,1,0) )
