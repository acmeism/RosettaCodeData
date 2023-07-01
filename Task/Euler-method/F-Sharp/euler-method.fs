let euler f (h : float) t0 y0 =
    (t0, y0)
    |> Seq.unfold (fun (t, y) -> Some((t,y), ((t + h), (y + h * (f t y)))))

let newtonCoolíng _ y = -0.07 * (y - 20.0)

[<EntryPoint>]
let main argv =
    let f  = newtonCoolíng
    let a = 0.0
    let y0 = 100.0
    let b = 100.0
    let h = 10.0
    (euler newtonCoolíng h a y0)
    |> Seq.takeWhile (fun (t,_) -> t <= b)
    |> Seq.iter (printfn "%A")
    0
