let getCalendar year =
    let day_of_week month year =
        let t =  [|0; 3; 2; 5; 0; 3; 5; 1; 4; 6; 2; 4|]
        let y = if month < 3 then year - 1 else year
        let m = month
        let d = 1
        (y + y / 4 - y / 100 + y / 400 + t.[m - 1] + d) % 7
        //0 = Sunday, 1 = Monday, ...

    let last_day_of_month month year =
        match month with
        | 2 -> if (0 = year % 4 && (0 = year % 400 || 0 <> year % 100)) then 29 else 28
        | 4 | 6 | 9 | 11 -> 30
        | _ -> 31

    let get_month_calendar year month =
        let min (x: int, y: int) = if x < y then x else y
        let ld = last_day_of_month month year
        let dw = 7 - (day_of_week month year)
        [|[|1..dw|];
          [|dw + 1..dw + 7|];
          [|dw + 8..dw + 14|];
          [|dw + 15..dw + 21|];
          [|dw + 22..min(ld, dw + 28)|];
          [|min(ld + 1, dw + 29)..ld|]|]

    let sb_fold (f:System.Text.StringBuilder -> 'a -> System.Text.StringBuilder) (sb:System.Text.StringBuilder) (xs:'a array)  =
        for x in xs do (f sb  x) |> ignore
        sb

    let sb_append (text:string) (sb:System.Text.StringBuilder) = sb.Append(text)

    let sb_appendln sb = sb |> sb_append "\n" |> ignore

    let sb_fold_in_range a b f sb = [|a..b|] |> sb_fold f sb |> ignore

    let mask_builder mask = Printf.StringFormat<string -> string>(mask)
    let center n (s:string) =
        let l = (n - s.Length) / 2 + s.Length
        let f n s = sprintf (mask_builder ("%" + (n.ToString()) + "s")) s
        (f l s) + (f (n - l) "")
    let left n (s:string)  = sprintf (mask_builder ("%-" + (n.ToString()) + "s")) s
    let right n (s:string) = sprintf (mask_builder ("%" + (n.ToString()) + "s")) s

    let array2string xs =
        let ys = xs |> Array.map (fun x -> sprintf "%2d " x)
        let sb = ys |> sb_fold (fun sb y -> sb.Append(y)) (new System.Text.StringBuilder())
        sb.ToString()

    let xsss =
        let m = get_month_calendar year
        [|1..12|] |> Array.map (fun i -> m i)

    let months = [|"January"; "February"; "March"; "April"; "May"; "June"; "July"; "August"; "September"; "October"; "November"; "December"|]

    let sb = new System.Text.StringBuilder()
    sb |> sb_append "\n" |> sb_append (center 74 (year.ToString())) |> sb_appendln
    for i in 0..3..9 do
      sb |> sb_appendln
      sb |> sb_fold_in_range i (i + 2) (fun sb i -> sb |> sb_append (center 21 months.[i]) |> sb_append "      ")
      sb |> sb_appendln
      sb |> sb_fold_in_range i (i + 2) (fun sb i -> sb |> sb_append "Su Mo Tu We Th Fr Sa " |> sb_append "      ")
      sb |> sb_appendln
      sb |> sb_fold_in_range i (i + 2) (fun sb i -> sb |> sb_append (right 21 (array2string (xsss.[i].[0]))) |> sb_append "      ")
      sb |> sb_appendln
      for j = 1 to 5 do
        sb |> sb_fold_in_range i (i + 2) (fun sb i -> sb |> sb_append (left 21 (array2string (xsss.[i].[j]))) |> sb_append "      ")
        sb |> sb_appendln
    sb.ToString()

let printCalendar year = getCalendar year
