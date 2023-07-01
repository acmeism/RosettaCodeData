type Point = { x:float; y:float }
type Line = { left : Point; right : Point }

let draw_start_html = """<!DOCTYPE html>
<html><head><title>Phytagoras tree</title>
<style type="text/css">polygon{fill:none;stroke:black;stroke-width:1}</style>
</head><body>
<svg width="640" height="640">"""

let draw_end_html = """Sorry, your browser does not support inline SVG.
</svg></body></html>"""

let svg_square x1 y1 x2 y2 x3 y3 x4 y4 =
    sprintf """<polygon points="%i %i %i %i %i %i %i %i" />"""
        (int x1) (int y1) (int x2) (int y2) (int x3) (int y3) (int x4) (int y4)

let out (x : string) = System.Console.WriteLine(x)

let sprout line =
    let dx = line.right.x - line.left.x
    let dy = line.left.y - line.right.y
    let line2 = {
        left = { x = line.left.x - dy; y = line.left.y - dx };
        right = { x = line.right.x - dy ; y = line.right.y - dx }
    }
    let triangleTop = {
        x = line2.left.x + (dx - dy) / 2.;
        y = line2.left.y - (dx + dy) / 2.
    }
    [
        { left = line2.left; right = triangleTop }
        { left = triangleTop; right = line2.right }
    ]

let draw_square line =
    let dx = line.right.x - line.left.x
    let dy = line.left.y - line.right.y
    svg_square line.left.x line.left.y line.right.x line.right.y
               (line.right.x - dy) (line.right.y - dx) (line.left.x - dy) (line.left.y - dx)

let rec generate lines = function
| 0 -> ()
| n ->
    let next =
        lines
        |> List.collect (fun line ->
            (draw_square >> out) line
            sprout line
        )
    generate next (n-1)


[<EntryPoint>]
let main argv =
    let depth = 1 + if argv.Length > 0 then (System.UInt32.Parse >> int) argv.[0] else 2
    out draw_start_html
    generate [{ left = { x = 275.; y = 500. }; right = { x = 375.; y = 500. } }] depth
    out draw_end_html
    0
