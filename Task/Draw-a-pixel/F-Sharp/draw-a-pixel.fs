open System.Windows.Forms
open System.Drawing

let f = new Form()
f.Size <- new Size(320,240)
f.Paint.Add(fun e -> e.Graphics.FillRectangle(Brushes.Red, 100, 100 ,1,1))
Application.Run(f)
