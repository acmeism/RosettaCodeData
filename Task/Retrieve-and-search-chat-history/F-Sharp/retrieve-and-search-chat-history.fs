#!/usr/bin/env fsharpi
let server_tz =
    try
        // CLR on Windows
        System.TimeZoneInfo.FindSystemTimeZoneById("W. Europe Standard Time")
    with
        // Mono
        :? System.TimeZoneNotFoundException ->
            System.TimeZoneInfo.FindSystemTimeZoneById("Europe/Berlin")

let get url =
    let req = System.Net.WebRequest.Create(System.Uri(url))
    use resp = req.GetResponse()
    use stream = resp.GetResponseStream()
    use reader = new System.IO.StreamReader(stream)
    reader.ReadToEnd()

let grep needle (haystack : string) =
    haystack.Split('\n')
    |> Array.toList
    |> List.filter (fun x -> x.Contains(needle))

let genUrl n =
    let day = System.DateTime.UtcNow.AddDays(float n)
    let server_dt = System.TimeZoneInfo.ConvertTimeFromUtc(day, server_tz)
    let timestamp = server_dt.ToString("yyyy-MM-dd")
    sprintf "http://tclers.tk/conferences/tcl/%s.tcl" timestamp

let _ =
    match fsi.CommandLineArgs with
    | [|_; needle|] ->
        let back = 10
        for i in -back .. 0 do
            let url = genUrl i
            let found = url |> get |> grep needle |> String.concat "\n"
            if found <> "" then printfn "%s\n------\n%s\n------\n" url found
            else ()
    | x ->
        printfn "Usage: %s literal" (Array.get x 0)
        System.Environment.Exit(1)
