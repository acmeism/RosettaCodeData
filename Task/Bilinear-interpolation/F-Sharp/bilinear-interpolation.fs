open System
open System.Drawing

let lerp (s:float) (e:float) (t:float) =
    s + (e - s) * t

let blerp c00 c10 c01 c11 tx ty =
    lerp (lerp c00 c10 tx) (lerp c01 c11 tx) ty

let scale (self:Bitmap) (scaleX:float) (scaleY:float) =
    let newWidth  = int ((float self.Width)  * scaleX)
    let newHeight = int ((float self.Height) * scaleY)
    let newImage = new Bitmap(newWidth, newHeight, self.PixelFormat)
    for x in 0..newWidth-1 do
        for y in 0..newHeight-1 do
            let gx = (float x) / (float newWidth) *  (float (self.Width  - 1))
            let gy = (float y) / (float newHeight) * (float (self.Height - 1))
            let gxi = int gx
            let gyi = int gy
            let c00 = self.GetPixel(gxi,     gyi)
            let c10 = self.GetPixel(gxi + 1, gyi)
            let c01 = self.GetPixel(gxi,     gyi + 1)
            let c11 = self.GetPixel(gxi + 1, gyi + 1)
            let red   = int (blerp (float c00.R) (float c10.R) (float c01.R) (float c11.R) (gx - (float gxi)) (gy - (float gyi)))
            let green = int (blerp (float c00.G) (float c10.G) (float c01.G) (float c11.G) (gx - (float gxi)) (gy - (float gyi)))
            let blue  = int (blerp (float c00.B) (float c10.B) (float c01.B) (float c11.B) (gx - (float gxi)) (gy - (float gyi)))
            let rgb = Color.FromArgb(red, green, blue)
            newImage.SetPixel(x, y, rgb)
    newImage

// Taken from https://stackoverflow.com/a/2362114
let castAs<'T when 'T : null> (o:obj) =
    match o with
    | :? 'T as res -> res
    | _ -> Unchecked.defaultof<'T>

[<EntryPoint>]
let main _ =
    let newImage = Image.FromFile("Lenna100.jpg")
    let oi = castAs<Bitmap>(newImage)
    if oi = null then
        Console.WriteLine("Could not open the source file.")
    else
        let result = scale oi 1.6 1.6
        result.Save("Lenna100_larger.jpg")

    0 // return an integer exit code
