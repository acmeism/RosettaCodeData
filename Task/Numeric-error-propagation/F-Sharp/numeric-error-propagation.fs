let sqr (x : float) = x * x
let abs (x : float)  = System.Math.Abs x
let pow = System.Math.Pow

type Approx (value : float, sigma : float) =
    member this.value = value
    member this.sigma = sigma

    static member (~-) (x : Approx) = Approx (- x.value, x.sigma)
    static member (%+) (x: Approx, y : float) = Approx (x.value + y, x.sigma)
    static member (%+) (y : float, x : Approx) = x %+ y
    static member (%+) (x : Approx, y : Approx) =
        Approx (x.value + y.value, sqrt((sqr x.sigma)+(sqr y.sigma)))
    static member (%-) (x: Approx, y : float) = Approx (x.value - y, x.sigma)
    static member (%-) (y : float, x : Approx) = (-x) %+ y
    static member (%-) (x : Approx, y : Approx) = x %+ (-y)
    static member (%*) (x : Approx, y : float) = Approx (y * x.value, abs(y * x.sigma))
    static member (%*) (y : float, x : Approx) = x %* y
    static member (%*) (x : Approx, y : Approx) =
        let v = x.value * y.value
        Approx (v, v * sqrt(sqr(x.sigma/x.value))+sqr(y.sigma/y.value))
    static member (%/) (x : Approx, y : Approx) =
        Approx (x.value / y.value, sqrt(sqr(x.sigma/x.value))+sqr(y.sigma/y.value))
    static member (%^) (x : Approx, y : float) =
        if y < 0. then failwith ("Cannot raise the power with a negative number " + y.ToString())
        let v = pow(x.value,y)
        Approx (v, abs(v * y * x.sigma / x.value))

    override this.ToString() = sprintf "%.2f ±%.2f" value sigma

[<EntryPoint>]
let main argv =
    let x1 = Approx (100., 1.1)
    let y1 = Approx (50., 1.2)
    let x2 = Approx (200., 2.2)
    let y2 = Approx (100., 2.3)

    printfn "Distance: %A" ((((x1 %- x2) %^ 2.) %+ ((y1 %- y2) %^ 2.)) %^ 0.5)
    0
