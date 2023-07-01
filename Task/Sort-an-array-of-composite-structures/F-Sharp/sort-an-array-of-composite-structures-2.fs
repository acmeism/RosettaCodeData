type Person = { name:string; id:int }
let persons2 = [{name="Joe"; id=120}; {name="foo"; id=31}; {name="bar"; id=51}]
let sorted = List.sortBy (fun p -> p.id) persons2
for p in sorted do printfn "%A" p
