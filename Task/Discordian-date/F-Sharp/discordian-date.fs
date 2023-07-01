open System

let seasons = [| "Chaos"; "Discord"; "Confusion"; "Bureaucracy"; "The Aftermath" |]

let ddate (date:DateTime) =
    let dyear = date.Year + 1166
    let leapYear = DateTime.IsLeapYear(date.Year)

    if leapYear && date.Month = 2 && date.Day = 29 then
        sprintf "St. Tib's Day, %i YOLD" dyear
    else
        // compensate for St. Tib's Day
        let dayOfYear = (if leapYear && date.DayOfYear >= 60 then date.DayOfYear - 1 else date.DayOfYear) - 1
        let season, dday = Math.DivRem(dayOfYear, 73)
        sprintf "%s %i, %i YOLD" seasons.[season] (dday+1) dyear

[<EntryPoint>]
let main argv =
    let p = Int32.Parse
    Seq.ofArray("2012-02-28 2012-02-29 2012-03-01 2010-07-22 2015-10-19 2015-10-20".Split())
    |> Seq.map(fun (s:string) ->
        let d = s.Split('-')
        (s, DateTime(p(d.[0]),p(d.[1]),p(d.[2]))))
    |> Seq.iter(fun (s,d) -> printfn "%s is %s" s (ddate d))
    0
