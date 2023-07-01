// A function to generate department numbers. Nigel Galloway: May 2nd., 2018
type dNum = {Police:int; Fire:int; Sanitation:int}
let fN n=n.Police%2=0&&n.Police+n.Fire+n.Sanitation=12&&n.Police<>n.Fire&&n.Police<>n.Sanitation&&n.Fire<>n.Sanitation
List.init (7*7*7) (fun n->{Police=n%7+1;Fire=(n/7)%7+1;Sanitation=(n/49)+1})|>List.filter fN|>List.iter(printfn "%A")
