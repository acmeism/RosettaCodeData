let d = [("key","val");("other key","other val")] |> Map.ofList
let newd = d.Add("new key","new val")

let takeVal (d:Map<string,string>) =
    match d.TryFind("key") with
        | Some(v) -> printfn "%s" v
        | None -> printfn "not found"
