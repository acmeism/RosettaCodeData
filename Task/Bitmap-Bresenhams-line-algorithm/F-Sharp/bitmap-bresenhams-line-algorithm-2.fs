open System.Windows
open System.Windows.Media.Imaging

[<System.STAThread>]
do
  let rand = System.Random()
  let n = 256
  let pixel = Array.create (n*n) 0uy
  let rand = System.Random().Next
  for _ in 1..100 do
    bresenham (fun x y -> pixel.[x+y*n] <- 255uy) (rand n, rand n) (rand n, rand n)
  let image = Controls.Image(Stretch=Media.Stretch.Uniform)
  let format = Media.PixelFormats.Gray8
  image.Source <-
    BitmapSource.Create(n, n, 1.0, 1.0, format, null, pixel, n)
  Window(Content=image, Title="Bresenham's line algorithm")
  |> (Application()).Run |> ignore
