open System

let show data = data |> Array.iter (printf "%d ") ; printfn ""
let split (data: int[]) pos = data.[0..pos], data.[(pos+1)..]

let flip items pos =
    let lower, upper = split items pos
    Array.append (Array.rev lower) upper

let pancakeSort items =
    let rec loop data limit =
        if limit <= 0 then data
        else
            let lower, upper = split data limit
            let indexOfMax = lower |> Array.findIndex ((=) (Array.max lower))
            let partialSort = Array.append (flip lower indexOfMax |> Array.rev) upper
            loop partialSort (limit-1)

    loop items ((Array.length items)-1)
