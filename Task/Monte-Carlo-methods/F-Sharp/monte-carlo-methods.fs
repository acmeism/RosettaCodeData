let print x = printfn "%A" x

let MonteCarloPiGreco niter =
    let eng = System.Random()
    let action () =
        let x: float = eng.NextDouble()
        let y: float = eng.NextDouble()
        let res: float = System.Math.Sqrt(x**2.0 + y**2.0)
        if res < 1.0 then
            1
        else
            0
    let res = [ for x in 1..niter do yield action() ]
    let tmp: float = float(List.reduce (+) res) / float(res.Length)
    4.0*tmp

MonteCarloPiGreco 1000 |> print
MonteCarloPiGreco 10000 |> print
MonteCarloPiGreco 100000 |> print
