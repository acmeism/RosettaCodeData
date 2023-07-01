let jdn (year, month, day) =
    let a = (14 - month) / 12
    let y = year + 4800 - a
    let m = month + 12 * a - 3
    day + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045

let date_from_jdn jdn =
    let j = jdn + 32044
    let g = j / 146097
    let dg = j % 146097
    let c = (dg / 36524 + 1) * 3 / 4
    let dc = dg - c * 36524
    let b = dc / 1461
    let db = dc % 1461
    let a = (db / 365 + 1) * 3 / 4
    let da = db - a * 365
    let y = g * 400 + c * 100 + b * 4 + a
    let m = (da * 5 + 308) / 153 - 2
    let d = da - (m + 4) * 153 / 5 + 122
    (y - 4800 + (m + 2) / 12, (m + 2) % 12 + 1, d + 1)

[<EntryPoint>]
let main argv =
    let year = System.Int32.Parse(argv.[0])
    [for m in 1..12 do yield jdn (year,m+1,0)]
    |> List.map (fun x -> date_from_jdn (x - (x+1)%7))
    |> List.iter (printfn "%A")
    0
