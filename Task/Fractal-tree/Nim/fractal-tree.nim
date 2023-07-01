import math
import strformat

const
  Width = 1000
  Height = 1000
  TrunkLength = 400
  ScaleFactor = 0.6
  StartingAngle = 1.5 * PI
  DeltaAngle = 0.2 * PI

proc drawTree(outfile: File; x, y, len, theta: float) =
  if len >= 1:
    let x2 = x + len * cos(theta)
    let y2 = y + len * sin(theta)
    outfile.write(
      fmt"<line x1='{x}' y1='{y}' x2='{x2}' y2='{y2}' style='stroke:white;stroke-width:1'/>\n")
    outfile.drawTree(x2, y2, len * ScaleFactor, theta + DeltaAngle)
    outFile.drawTree(x2, y2, len * ScaleFactor, theta - DeltaAngle)

let outsvg = open("tree.svg", fmWrite)
outsvg.write("""<?xml version='1.0' encoding='utf-8' standalone='no'?>
                <!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
                'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
                <svg width='100%%' height='100%%' version='1.1'
                xmlns='http://www.w3.org/2000/svg'>\n
                <rect width="100%" height="100%" fill="black"/>\n""")

outsvg.drawTree(0.5 * Width, Height, TrunkLength, StartingAngle)
outsvg.write("</svg>\n")   # View file tree.svg in browser.
