open System

let digsum b n =
    let rec loop acc = function
        | n when n > 0 ->
            let m, r = Math.DivRem(n, b)
            loop (acc + r) m
        | _ -> acc
    loop 0 n

[<EntryPoint>]
let main argv =
    let rec show = function
        | n :: b :: r -> printf " %d" (digsum b n); show r
        | _ -> ()

    show [1; 10; 1234; 10; 0xFE; 16; 0xF0E; 16]     // ->  1 10 29 29
    0
