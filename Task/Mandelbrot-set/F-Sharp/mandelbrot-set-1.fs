open System.Drawing
open System.Windows.Forms
type Complex =
    {
        re : float;
        im : float
    }
let cplus (x:Complex) (y:Complex) : Complex =
    {
        re = x.re + y.re;
        im = x.im + y.im
    }
let cmult (x:Complex) (y:Complex) : Complex =
    {
        re = x.re * y.re - x.im * y.im;
        im = x.re * y.im + x.im * y.re;
    }

let norm (x:Complex) : float =
    x.re*x.re + x.im*x.im

type Mandel = class
    inherit Form
    static member xPixels = 500
    static member yPixels = 500
    val mutable bmp : Bitmap
    member x.mandelbrot xMin xMax yMin yMax maxIter =
        let rec mandelbrotIterator z c n =
            if (norm z) > 2.0 then false else
                match n with
                    | 0 -> true
                    | n -> let z' = cplus ( cmult z z ) c in
                            mandelbrotIterator z' c (n-1)
        let dx = (xMax - xMin) / (float (Mandel.xPixels))
        let dy = (yMax - yMin) / (float (Mandel.yPixels))
        in
        for xi = 0 to Mandel.xPixels-1 do
            for yi = 0 to Mandel.yPixels-1 do
                let c = {re = xMin + (dx * float(xi) ) ;
                         im = yMin + (dy * float(yi) )} in
                if (mandelbrotIterator {re=0.;im=0.;} c maxIter) then
                    x.bmp.SetPixel(xi,yi,Color.Azure)
                else
                    x.bmp.SetPixel(xi,yi,Color.Black)
            done
        done

    member public x.generate () = x.mandelbrot (-1.5) 0.5 (-1.0) 1.0 200 ; x.Refresh()

    new() as x = {bmp = new Bitmap(Mandel.xPixels , Mandel.yPixels)} then
        x.Text <- "Mandelbrot set" ;
        x.Width <- Mandel.xPixels ;
        x.Height <- Mandel.yPixels ;
        x.BackgroundImage <- x.bmp;
        x.generate();
        x.Show();
end

let f = new Mandel()
do Application.Run(f)
