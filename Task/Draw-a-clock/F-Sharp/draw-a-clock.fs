open System.Text.RegularExpressions

let numberTemplate = """
 _     _  _     _     __ _  _
/ \ /|  ) _)|_||_  /   /(_)(_) *
\_/  | /_ _)  | _)(_) / (_) /  *
"""
let g =
    numberTemplate.Split([|'\n';'\r'|], System.StringSplitOptions.RemoveEmptyEntries)
    |> Array.map (fun s ->
        Regex.Matches(s, "...")
        |> Seq.cast<Match>
        |> Seq.map (fun m -> m.ToString())
        |> Seq.toArray)

let idx c =
    let v c = ((int) c) - ((int) '0')
    let i = v c
    if 0 <= i && i <= 9 then i
    elif c = ':' then 10
    else failwith ("Cannot draw character " + c.ToString())

let draw (s :string) =
    System.Console.Clear()
    g
    |> Array.iter (fun a ->
        s.ToCharArray() |> Array.iter (fun c ->
            let i = idx c
            printf "%s" (a.[i]))
        printfn ""
        )

[<EntryPoint>]
let main argv =
    let showTime _ = draw (System.String.Format("{0:HH:mm:ss}", (System.DateTime.Now)))
    let timer = new System.Timers.Timer(500.)
    timer.AutoReset <- true // The timer triggers cyclically
    timer.Elapsed // An event stream
    |> Observable.subscribe showTime |> ignore // Subscribe to the event stream
    timer.Start() // Now it counts
    System.Console.ReadLine() |> ignore // Until return is hit
    showTime ()
    0
