from visual import *
from visual.graph import *

plot1 = gdisplay( title='VPython Plot-Demo',
                  xtitle='x',
                  ytitle='y    (click and drag mouse to see coordinates)',
                  foreground=color.black,
                  background=color.white,
                  x=0, y=0,
                  width=400, height=400,
                  xmin=0, xmax=10,
                  ymin=0, ymax=200 )

f1 = gdots(color=color.red)                 # create plot-object

f1.plot(pos= (0,   2.7), color=color.blue ) # add a single point
f1.plot(pos=[(1,   2.8),                    # add a list of points
             (2,  31.4),
             (3,  38.1),
             (4,  58.0),
             (5,  76.2),
             (6, 100.5),
             (7, 130.0),
             (8, 149.3),
             (9, 180.0) ]
        )
label(display=plot1.display, text="Look here",
      pos=(6,100.5), xoffset=30,yoffset=-20 )
