open Newtonsoft.Json
type Person = {ID: int; Name:string}
let xs = [{ID = 1; Name = "First"} ; { ID = 2; Name = "Second"}]

let json = JsonConvert.SerializeObject(xs)
json |> printfn "%s"

let xs1 = JsonConvert.DeserializeObject<Person list>(json)
xs1 |> List.iter(fun x -> printfn "%i  %s" x.ID x.Name)
