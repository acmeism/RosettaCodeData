open System.Drawing
open System.Windows.Forms

let showGraphic (colorForIter: int -> Color) (width: int) (height:int) maxIter view =
  new Form()
  |> fun frm ->
    frm.Width <- width
    frm.Height <- height
    frm.BackgroundImage <-
      new Bitmap(width,height)
      |> fun bmp ->
        getMandelbrotValues width height maxIter view
        |> List.mapi (fun y row->row |> List.mapi (fun x v->((x,y),v))) |> List.collect id
        |> List.iter (fun ((x,y),v) -> bmp.SetPixel(x,y,(colorForIter v)))
        bmp
    frm.Show()

let toColor = (function | 0 -> (0,0,0) | n -> ((31 &&& n) |> fun x->(0, 18 + x * 5, 36 + x * 7))) >> Color.FromArgb

showGraphic toColor 640 480 5000 ((-2.0,1.0),(-1.0,1.0))
