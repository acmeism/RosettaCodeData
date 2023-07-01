open System

let ordinalsuffix n =
    let suffixstrings = [|"th"; "st"; "nd"; "rd"|]
    let (d, r) = Math.DivRem(n, 10)
    n.ToString() + suffixstrings.[ if r < 4 && (d &&& 1) = 0 then r else 0 ]


[<EntryPoint>]
let main argv =
    let show = (Seq.iter (ordinalsuffix >> (printf " %s"))) >> (Console.WriteLine)
    [0..25] |> show
    [250..265] |> show
    [1000..1025] |> show
    0
