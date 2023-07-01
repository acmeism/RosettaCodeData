open System.Drawing

let (|F1|F2|F3|F4|) r =
    if r < 0.01 then F1
    else if r < 0.08 then F3
    else if r < 0.15 then F4
    else F2

let barnsleyFernFunction (x, y) = function
    | F1 -> (0.0, 0.16*y)
    | F2 -> ((0.85*x + 0.04*y), (-0.04*x + 0.85*y + 1.6))
    | F3 -> ((0.2*x - 0.26*y), (0.23*x + 0.22*y + 1.6))
    | F4 -> ((-0.15*x + 0.28*y), (0.26*x + 0.24*y + 0.44))

let barnsleyFern () =
    let rnd = System.Random()
    (0.0, 0.0)
    |> Seq.unfold (fun point -> Some (point, barnsleyFernFunction point (rnd.NextDouble())))

let run width height =
    let emptyBitmap = new Bitmap(int width,int height)
    let bitmap =
        barnsleyFern ()
        |> Seq.take 250000 // calculate points
        |> Seq.map (fun (x,y) -> (int (width/2.0+(width*x/11.0)), int (height-(height*y/11.0)))) // transform to pixels
        |> Seq.fold (fun (b:Bitmap) (x,y) -> b.SetPixel(x-1,y-1,Color.ForestGreen); b) emptyBitmap // add pixels to bitmap
    bitmap.Save("BFFsharp.png")
