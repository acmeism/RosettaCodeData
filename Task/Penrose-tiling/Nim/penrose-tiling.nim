import math, strformat, tables

const Lindenmayer = {'A': "",
                     'M': "OA++PA----NA[-OA----MA]++",
                     'N': "+OA--PA[---MA--NA]+",
                     'O': "-MA++NA[+++OA++PA]-",
                     'P': "--OA++++MA[+PA++++NA]--NA"}.toTable

var penrose = "[N]++[N]++[N]++[N]++[N]"

for _ in 1..4:
  var next = ""
  for ch in penrose:
    next.add Lindenmayer.getOrDefault(ch, $ch)
  penrose = move(next)

var
  x, y = 160.0
  theta = PI / 5
  r = 20.0

var svg = ""
var stack: seq[(float, float, float)]

for ch in penrose:
  case ch
  of 'A':
    let (nx, ny) = (x + r * cos(theta), y + r * sin(theta))
    svg.add &"<line x1='{x:.1f}' y1='{y:.1f}' x2='{nx:.1f}' y2='{ny:.1f}'"
    svg.add " style='stroke:rgb(255,165,0)'/>\n"
    (x, y) = (nx, ny)
  of '+':
    theta += PI / 5
  of '-':
    theta -= PI / 5
  of '[':
    stack.add (x, y, theta)
  of ']':
    (x, y, theta) = stack.pop()
  else:
    discard

let svgFile = "penrose_tiling.svg".open(fmWrite)
svgFile.write """
<svg xmlns="http://www.w3.org/2000/svg" height="350" width="350">
<rect height="100%%" width="100%%" style="fill:black" />
"""
svgFile.write svg, "</svg>"
svgFile.close()
