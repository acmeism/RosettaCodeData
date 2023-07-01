open System.Windows.Forms
open System.Drawing
open System

let sz = 300
let polygon = [Point(sz/2, int (float sz*(1.0-sin(Math.PI/3.0)))); Point(0, sz-1); Point(sz-1, sz-1)]

let bmp = new Bitmap(sz, sz)
let paint (p: Point) = bmp.SetPixel(p.X, p.Y, Color.Black)

let random = Random()
let seed = Point(int (random.NextDouble() * float sz), int (random.NextDouble() * float sz))
let midpoint (p1: Point) (p2: Point) = Point((p1.X + p2.X) / 2, (p1.Y + p2.Y) / 2)
let randomVertex() = polygon.[random.Next(polygon.Length)]
let step p _ =
    paint p
    midpoint p (randomVertex())
Seq.init 100000 id |> Seq.fold step seed

let f = new Form()
f.ClientSize <- bmp.Size
f.Paint.Add (fun args -> args.Graphics.DrawImage(bmp, Point(0, 0)))
f.Show()
