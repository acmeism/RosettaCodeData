open FSharp.Data
type Person = {ID: int; Name:string}
type People = JsonProvider<""" [{"ID":1,"Name":"First"},{"ID":2,"Name":"Second"}] """>

People.GetSamples()
|> Array.map(fun x -> {ID = x.Id; Name = x.Name} )
|> Array.iter(fun x -> printfn "%i  %s" x.ID x.Name)
