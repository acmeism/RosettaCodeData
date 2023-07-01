let count (a: _ [,]) x y =
  let m, n = a.GetLength 0, a.GetLength 1
  let mutable c = 0
  for x in x-1..x+1 do
    for y in y-1..y+1 do
      if x>=0 && x<m && y>=0 && y<n && a.[x, y] then
        c <- c + 1
  if a.[x, y] then c-1 else c

let rule (a: _ [,]) x y =
  match a.[x, y], count a x y with
  | true, (2 | 3) | false, 3 -> true
  | _ -> false

open System.Windows
open System.Windows.Media.Imaging

[<System.STAThread>]
do
  let rand = System.Random()
  let n = 256
  let game = Array2D.init n n (fun _ _ -> rand.Next 2 = 0) |> ref
  let image = Controls.Image(Stretch=Media.Stretch.Uniform)
  let format = Media.PixelFormats.Gray8
  let pixel = Array.create (n*n) 0uy
  let update _ =
    game := rule !game |> Array2D.init n n
    for x in 0..n-1 do
      for y in 0..n-1 do
        pixel.[x+y*n] <- if (!game).[x, y] then 255uy else 0uy
    image.Source <-
      BitmapSource.Create(n, n, 1.0, 1.0, format, null, pixel, n)
  Media.CompositionTarget.Rendering.Add update
  Window(Content=image, Title="Game of Life")
  |> (Application()).Run |> ignore
