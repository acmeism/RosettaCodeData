let (cos, sin, pi) = System.Math.Cos, System.Math.Sin, System.Math.PI

let (width, height) = 1000., 1000. // image dimension
let scale = 6./10.                 // branch scale relative to trunk
let length = 400.                  // trunk size

let rec tree x y length angle =
    if length >= 1. then
        let (x2, y2) = x + length * (cos angle),  y + length * (sin angle)
        printfn "<line x1='%f' y1='%f' x2='%f' y2='%f' style='stroke:rgb(0,0,0);stroke-width:1'/>"
            x y x2 y2
        tree x2 y2 (length*scale) (angle + pi/5.)
        tree x2 y2 (length*scale) (angle - pi/5.)

printfn "<?xml version='1.0' encoding='utf-8' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='100%%' height='100%%' version='1.1'
xmlns='http://www.w3.org/2000/svg'>"
tree (width/2.) height length (3.*pi/2.)
printfn "</svg>"
