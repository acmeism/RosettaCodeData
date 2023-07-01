open FSharp.Data
open FSharp.Data.JsonExtensions

type Person = {ID: int; Name:string}
let xs = [{ID = 1; Name = "First"} ; { ID = 2; Name = "Second"}]

let infos = xs |> List.map(fun x -> JsonValue.Record([| "ID", JsonValue.Number(decimal x.ID); "Name", JsonValue.String(x.Name) |]))
            |> Array.ofList |> JsonValue.Array

infos |> printfn "%A"
match JsonValue.Parse(infos.ToString()) with
| JsonValue.Array(x) -> x |> Array.map(fun x -> {ID = System.Int32.Parse(string x?ID); Name = (string x?Name)})
| _ -> failwith "fail json"
|> Array.iter(fun x -> printfn "%i  %s" x.ID x.Name)
