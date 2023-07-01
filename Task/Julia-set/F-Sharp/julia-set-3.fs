open System.Drawing
open System.Windows.Forms

let showGraphic (colorForIter: int -> Color) width height centerX centerY zoom maxIter =
  new Form()
  |> fun frm ->
    frm.Width <- width
    frm.Height <- height
    frm.BackgroundImage <-
      new Bitmap(width,height)
      |> fun bmp ->
        getJuliaValues width height centerX centerY zoom maxIter
        |> List.mapi (fun y row->row |> List.mapi (fun x v->((x,y),v))) |> List.collect id
        |> List.iter (fun ((x,y),v) -> bmp.SetPixel(x,y,(colorForIter v)))
        bmp
    frm.Show()

let toColor = (function | 0 -> (0,0,0) | n -> ((31 &&& n) |> fun x->(0, 18 + x * 5, 36 + x * 7))) >> Color.FromArgb

showGraphic toColor 640 480 -0.7 0.27015 1.0 5000
