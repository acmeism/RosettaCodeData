const width = height = 1000.0
const trunklength = 400.0
const scalefactor = 0.6
const startingangle = 1.5 * pi
const deltaangle = 0.2 * pi

function tree(fh, x, y, len, theta)
   if len >= 1.0
       x2 = x + len * cos(theta)
       y2 = y + len * sin(theta)
       write(fh, "<line x1='$x' y1='$y' x2='$x2' y2='$y2' style='stroke:rgb(0,0,0);stroke-width:1'/>\n")
       tree(fh, x2, y2, len * scalefactor, theta + deltaangle)
       tree(fh, x2, y2, len * scalefactor, theta - deltaangle)
    end
end

outsvg = open("tree.svg", "w")
write(outsvg,
    """<?xml version='1.0' encoding='utf-8' standalone='no'?>
    <!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
    'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
    <svg width='100%%' height='100%%' version='1.1'
    xmlns='http://www.w3.org/2000/svg'>\n""")

tree(outsvg, 0.5 * width, height, trunklength, startingangle)

write(outsvg, "</svg>\n") # view file tree.svg in browser
