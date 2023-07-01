open System

let SequenceOfNonSquares =
    let nonsqr n = n+(int(0.5+Math.Sqrt(float (n))))
    let isqrt n = int(Math.Sqrt(float(n)))
    let IsSquare n = n = (isqrt n)*(isqrt n)
    {1 .. 999999}
    |> Seq.map(fun f -> (f, nonsqr f))
    |> Seq.filter(fun f -> IsSquare(snd f))
;;
