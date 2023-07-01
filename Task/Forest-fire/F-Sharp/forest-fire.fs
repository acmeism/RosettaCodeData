open System
open System.Diagnostics
open System.Drawing
open System.Drawing.Imaging
open System.Runtime.InteropServices
open System.Windows.Forms

module ForestFire =

    type Cell = Empty | Tree | Fire

    let rnd = new System.Random()
    let initial_factor = 0.35
    let ignition_factor = 1e-5 // rate of lightning strikes (f)
    let growth_factor = 2e-3   // rate of regrowth (p)
    let width = 640            // width of the forest region
    let height = 480           // height of the forest region

    let make_forest =
        Array2D.init height width
            (fun _ _ -> if rnd.NextDouble() < initial_factor then Tree else Empty)

    let count (forest:Cell[,]) row col =
        let mutable n = 0
        let h,w = forest.GetLength 0, forest.GetLength 1
        for r in row-1 .. row+1 do
            for c in col-1 .. col+1 do
                if r >= 0 && r < h && c >= 0 && c < w && forest.[r,c] = Fire then
                    n <- n + 1
        if forest.[row,col] = Fire then n-1 else n

    let burn (forest:Cell[,]) r c =
        match forest.[r,c] with
        | Fire -> Empty
        | Tree -> if rnd.NextDouble() < ignition_factor then Fire
                    else if (count forest r c) > 0 then Fire else Tree
        | Empty -> if rnd.NextDouble() < growth_factor then Tree else Empty

    // All the functions below this point are drawing the generated images to screen.
    let make_image (pixels:int[]) =
        let bmp = new Bitmap(width, height)
        let bits = bmp.LockBits(Rectangle(0,0,width,height), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb)
        Marshal.Copy(pixels, 0, bits.Scan0, bits.Height*bits.Width) |> ignore
        bmp.UnlockBits(bits)
        bmp

    // This function is run asynchronously to avoid blocking the main GUI thread.
    let run (box:PictureBox) (label:Label) = async {
        let timer = new Stopwatch()
        let forest = make_forest |> ref
        let pixel = Array.create (height*width) (Color.Black.ToArgb())
        let rec update gen =
            timer.Start()
            forest := burn !forest |> Array2D.init height width
            for y in 0..height-1 do
                for x in 0..width-1 do
                    pixel.[x+y*width] <- match (!forest).[y,x] with
                                            | Empty -> Color.Gray.ToArgb()
                                            | Tree -> Color.Green.ToArgb()
                                            | Fire -> Color.Red.ToArgb()
            let img = make_image pixel
            box.Invoke(MethodInvoker(fun () -> box.Image <- img)) |> ignore
            let msg = sprintf "generation %d @ %.1f fps" gen (1000./timer.Elapsed.TotalMilliseconds)
            label.Invoke(MethodInvoker(fun () -> label.Text <- msg )) |> ignore
            timer.Reset()
            update (gen + 1)
        update 0 }

    let main args =
        let form = new Form(AutoSize=true,
                            Size=new Size(800,600),
                            Text="Forest fire cellular automata")
        let box = new PictureBox(Dock=DockStyle.Fill,Location=new Point(0,0),SizeMode=PictureBoxSizeMode.StretchImage)
        let label = new Label(Dock=DockStyle.Bottom, Text="Ready")
        form.FormClosed.Add(fun eventArgs -> Async.CancelDefaultToken()
                                             Application.Exit())
        form.Controls.Add(box)
        form.Controls.Add(label)
        run box label |> Async.Start
        form.Show()
        Application.Run()
        0

#if INTERACTIVE
ForestFire.main [|""|]
#else
[<System.STAThread>]
[<EntryPoint>]
let main args = ForestFire.main args
#endif
