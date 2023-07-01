from __future__ import print_function, division
from visual import *
import itertools

title = "VPython: Draw a cuboid"
scene.title = title
print( "%s\n" % title )

msg = """
Drag with right mousebutton to rotate view.
Drag up+down with middle mousebutton to zoom.
Left mouseclick to show info.

Press x,X, y,Y, z,Z to rotate the box in single steps.
Press b, c,o,m to change background, color, opacity, material.
Press r,R to rotate, d,a for demo, automatic,  space to stop.
Press h to show this help,  ESC or q to quit.
"""

#...+....1....+....2....+....3....+....4....+....5....+....6....+....7....+...

## Rotate one step per keypress:

def rotX(obj, a) :
    obj.rotate( angle=a, axis=(1,0,0) )
def rotY(obj, a) :
    obj.rotate( angle=a, axis=(0,1,0) )
def rotZ(obj, a) :
    obj.rotate( angle=a, axis=(0,0,1) )

## Selection of background-colors:

bg_list = [color.gray(0.2), color.gray(0.4), color.gray(0.7), color.gray(0.9)]
bg = itertools.cycle(bg_list)
def backgr() :
    b = next(bg)
    print("BackgroundColor=",b)
    scene.background = b

## Selection of colors:

col_list = [color.white, color.red,  color.orange, color.yellow,
            color.green, color.blue, color.cyan,   color.magenta,
            color.black]
col = itertools.cycle(col_list)
#c = col.next()
#c = next(col)
def paint(obj) :
    c = next(col)
    print("Color=",c)
    obj.color = c

## Selection of opacity / transparancy :

opa_list = [1.0, 0.7, 0.5, 0.2]
opa = itertools.cycle(opa_list)
def solid(obj) :
    o = next(opa)
    print("opacity =",o)
    obj.opacity = o

## Selection of materials:

mName_list = ["None",
              "wood",
              "rough",
              "bricks",
              "glass",
              "earth",
              "plastic",
              "ice",
              "diffuse",
              "marble" ]
mat_list  = [ None,
              materials.wood,
              materials.rough,
              materials.bricks,
              materials.glass,
              materials.earth,
              materials.plastic,
              materials.ice,
              materials.diffuse,
              materials.marble ]
mName = itertools.cycle(mName_list)
mat   = itertools.cycle(mat_list)
def surface(obj) :
    mM = next(mat)
    mN = next(mName)
    print("Material:", mN)
    obj.material = mM
    obj.mat      = mN

## Selection for rotation-angle & axis :

rotAng_list = [ 0.0, 0.005, 0.0, -0.005 ]
rotDir_list = [ (1,0,0), (0,1,0), (0,0,1) ]

rotAng = itertools.cycle(rotAng_list)
rotDir = itertools.cycle(rotDir_list)

rotAn = next(rotAng)     # rotAn = 0.005
rotAx = next(rotDir)     # rotAx = (1,0,0)

def rotAngle() :
    global rotAn
    rotAn = next(rotAng)
    print("RotateAngle=",rotAn)

def rotAxis() :
    global rotAx
    rotAx = next(rotDir)
    print("RotateAxis=",rotAx)

## List of keypresses for demo:

#demoC_list = [ "h", "c", "a", "o", "m", "b" ]
demoCmd_list = "rcbr"+"robr"+"rmR_r?"
demoCmd = itertools.cycle(demoCmd_list)
def demoStep() :
    k = next(demoCmd)
    print("Demo:",k)
    cmd(k)

#...+....1....+....2....+....3....+....4....+....5....+....6....+....7....+...

def objCount():
    n=0
    for obj in scene.objects:
        n=n+1
    return n

def objInfo(obj) :
    print( "\nObject:", obj )
    print( "Pos:",  obj.pos,   "Size:", obj.size )
    print( "Axis:", obj.axis,  "Up:",   obj.up )
    print( "Color", obj.color, obj.opacity )
    print( "Mat:",  obj.mat,   obj.material )

def sceneInfo(sc) :
    print( "\nScene:",  sc )
    print( ".width x height:",   sc.width, "x", sc.height )
    print( ".range:",   sc.range, ".scale:", sc.scale )
    print( ".center:",  sc.center )    # Camera
    print( ".forward:", sc.forward, ".fov:", sc.fov )
    print( "Mouse:",    sc.mouse.camera, "ray:", sc.mouse.ray )
    print( ".ambient:", sc.ambient )
    print( "Lights:",   sc.lights  )    # distant_light
    print( "objects:", objCount(), scene.objects )

#...+....1....+....2....+....3....+....4....+....5....+....6....+....7....+...

scene.width  = 600
scene.height = 400
scene.range  = 4
#scene.autocenter = True
#scene.background = color.gray(0.2)
scene.background = next(bg)

autoDemo = -1

print( msg )


## Create cuboid (aka "box") :

# c = box()     # using default-values --> cube
# c = box(pos=(0,0,0), length=4, height=2, width=3, axis=(-0.1,-0.1,0.1) )
##c  = box(pos =( 0.0, 0.0, 0.0 ),
##         size=( 4, 2, 3 ),            # L,H,W
##         axis=( 1.0, 0.0, 0.0 ),
##         up  =( 0.0, 1.0, 0.0 ),
##         color   = color.orange,
##         opacity = 1.0,
##         material= materials.marble
##         )
c  = box(pos =( 0.0, 0.0, 0.0 ),
         size=( 4, 2, 3 ),            # L,H,W
         axis=( 1.0, 0.0, 0.0 ),
         up  =( 0.0, 1.0, 0.0 )
         )
print("Box:", c)
paint(c)     # c.color    = color.red
solid(c)     # c.opacity  = 1.0
surface(c)   # c.material = materials.marble

rotX(c,0.4)         # rotate box, to bring three faces into view
rotY(c,0.6)

#sceneInfo(scene)
#objInfo(c)
print("\nPress 'a' to start auto-running demo.")

#...+....1....+....2....+....3....+....4....+....5....+....6....+....7....+...


## Processing of input:

cCount = 0
def click():
    global cCount
    cCount=cCount+1
    sceneInfo(scene)
    objInfo(c)
scene.bind( 'click', click )

def keyInput():
    key = scene.kb.getkey()
    print( 'Key: "%s"' % key )

    if ( (key == 'esc') or (key == 'q') ) :
        print( "Bye!" )
        exit(0)
    else :
        cmd(key)
scene.bind('keydown', keyInput)

def cmd(key):
    global autoDemo
    if (key == 'h') :  print( msg )
    if (key == '?') :  print( msg )
    if (key == 's') :  sceneInfo(scene)
    if (key == 'i') :  objInfo(c)

    if (key == 'x') :  rotX(c, 0.1)
    if (key == 'X') :  rotX(c,-0.1)
    if (key == 'y') :  rotY(c, 0.1)
    if (key == 'Y') :  rotY(c,-0.1)
    if (key == 'z') :  rotZ(c, 0.1)
    if (key == 'Z') :  rotZ(c,-0.1)

    if (key == 'c') :  paint(c)
    if (key == 'o') :  solid(c)
    if (key == 'm') :  surface(c)

    if (key == 'b') :  backgr()
    if (key == 'r') :  rotAngle()
    if (key == 'R') :  rotAxis()
    if (key == 'd') :  demoStep()
    if (key == 'a') :  autoDemo = -autoDemo
    if (key == 'A') :  autoDemo = -autoDemo
    if (key == ' ') :  stop()

def stop() :
    global autoDemo, rotAn
    autoDemo = -1
    while rotAn <> 0 :
      rotAngle()
    print("**Stop**")

r=100
t=0
while True:                 # Animation-loop
    rate(50)
    t = t+1
    if rotAn != 0 :
        c.rotate( angle=rotAn, axis=rotAx )

    if t>=r :
        t=0
        if autoDemo>0 :
            demoStep()
