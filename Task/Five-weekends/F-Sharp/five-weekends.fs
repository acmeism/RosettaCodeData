open System

[<EntryPoint>]
let main argv =
    let (yearFrom, yearTo) = (1900, 2100)

    let monthsWith5We year =
        [1; 3; 5; 7; 8; 10; 12] |>
        List.filter (fun month -> DateTime(year, month, 1).DayOfWeek = DayOfWeek.Friday)

    let ym5we =
        [yearFrom .. yearTo]
        |> List.map (fun year -> year, (monthsWith5We year))

    let countMonthsWith5We =
        ym5we
        |> List.sumBy (snd >> List.length)

    let countYearsWithout5WeMonths =
        ym5we
        |> List.sumBy (snd >> List.isEmpty >> (function|true->1|_->0))

    let allMonthsWith5we =
        ym5we
        |> List.filter (snd >> List.isEmpty >> not)

    printfn "%d months in the range of years from %d to %d have 5 weekends."
        countMonthsWith5We yearFrom yearTo
    printfn "%d years in the range of years from %d to %d have no month with 5 weekends."
        countYearsWithout5WeMonths yearFrom yearTo
    printfn "Months with 5 weekends: %A ... %A"
        (List.take 5 allMonthsWith5we)
        (List.take 5 (List.skip ((List.length allMonthsWith5we) - 5) allMonthsWith5we))
    0
