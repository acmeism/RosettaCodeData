//Percentage difference between 2 images. Nigel Galloway April 18th., 2018
let img50 = new System.Drawing.Bitmap("Lenna50.jpg")
let img100 = new System.Drawing.Bitmap("Lenna100.jpg")
let diff=Seq.cast<System.Drawing.Color*System.Drawing.Color>(Array2D.init img50.Width img50.Height (fun n g->(img50.GetPixel(n,g),img100.GetPixel(n,g))))|>Seq.fold(fun i (e,l)->i+abs(int(e.R)-int(l.R))+abs(int(e.B)-int(l.B))+abs(int(e.G)-int(l.G))) 0
printfn "%f" ((float diff)*100.00/(float(img50.Height*img50.Width)*255.0*3.0))
