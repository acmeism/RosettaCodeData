open System.Windows.Forms
open System.Drawing
open System.Drawing.Imaging
open System.Runtime.InteropServices
open System.Diagnostics
open Microsoft.FSharp.NativeInterop
#nowarn "9"

let rnd = System.Random()

// Draw pixels using unsafe native pointer accessor.
// This updates the bitmap as fast as possible.
let drawbits_fast (size:int) (bits:BitmapData) =
    let mutable (p:nativeptr<byte>) = NativePtr.ofNativeInt(bits.Scan0)
    for n = 0 to size-1 do
        let c = rnd.Next(2) * 255
        NativePtr.set p 2 (byte c)
        NativePtr.set p 1 (byte c)
        NativePtr.set p 0 (byte c)
        NativePtr.set p 3 (byte 255)
        p <- NativePtr.add p 4

// A reasonably efficient updater using marshalling to copy an array of generated
// integers onto the managed bitmap pixel data (see the C# example as well).
let drawbits_safe (size:int) (bits:BitmapData) =
    let data = Array.init size (fun n ->
            let c = rnd.Next(2) * 255
            0xff000000 ||| (c <<< 16) ||| (c <<< 8) ||| c)
    Marshal.Copy(data, 0, bits.Scan0, size) |> ignore

// Create a new bitmap and update using the specified function
let make_image (width:int) (height:int) f =
    let size = width * height
    let bmp = new Bitmap(width, height)
    let bits = bmp.LockBits(Rectangle(0,0,width,height), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb)
    f size bits
    bmp.UnlockBits(bits)
    bmp

// Draw 30 frames and record the time and display the frames per second
// This function is run asynchronously to avoid blocking the main GUI thread.
let drawImage (box:PictureBox) (label:Label) f = async {
    while true do
        let timer = new Stopwatch()
        timer.Start()
        for frames = 0 to 29 do
            let bmp = make_image 320 240 f
            box.Image <- bmp
        timer.Stop()
        let fps = 30000. / timer.Elapsed.TotalMilliseconds
        label.Text <- sprintf "%.1f fps" fps }

[<System.STAThread>]
[<EntryPoint>]
let main args =
    let form = new Form(AutoSize=true,
                        Size=new Size(0,0),
                        Text="image noise demo")
    let panel = new FlowLayoutPanel(AutoSize=true,FlowDirection=FlowDirection.TopDown)
    let box = new PictureBox(AutoSize=true)
    let label = new Label(AutoSize=true, Text="Ready")
    form.FormClosed.Add(fun eventArgs -> Async.CancelDefaultToken()
                                         Application.Exit())
    form.Controls.Add(panel)
    panel.Controls.Add(box)
    panel.Controls.Add(label)
    if args.Length > 0 && args.[0] = "-safe" then
        drawImage box label drawbits_safe |> Async.Start
    else
        drawImage box label drawbits_fast |> Async.Start
    form.Show()
    Application.Run()
    0
