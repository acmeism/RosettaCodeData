open System.Drawing
open System.Windows.Forms

let GetPixel x y =
    use img = new Bitmap(1,1)
    use g = Graphics.FromImage(img)
    g.CopyFromScreen(new Point(x,y), new Point(0,0), new Size(1,1))
    let clr = img.GetPixel(0,0)
    (clr.R, clr.G, clr.B)

let GetPixelAtMouse () =
    let pt = Cursor.Position
    GetPixel pt.X pt.Y
