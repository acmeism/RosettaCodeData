let cin = [ 0.06m .. 0.05m ..1.01m ]
let cout = [0.1m; 0.18m] @ [0.26m .. 0.06m .. 0.44m] @ [0.50m .. 0.04m .. 0.98m] @ [1.m]

let priceadjuster p =
    let rec bisect lo hi =
        if lo < hi then
            let mid = (lo+hi)/2.
            let left = p < cin.[int mid]
            bisect (if left then lo else mid+1.) (if left then mid else hi)
        else lo

    if p < 0.m || 1.m < p then p
    else cout.[int (bisect 0. (float cin.Length))]

[ 0.m .. 0.01m .. 1.m ]
|> Seq.ofList
|> Seq.iter (fun p -> printfn "%.2f -> %.2f" p (priceadjuster p))
