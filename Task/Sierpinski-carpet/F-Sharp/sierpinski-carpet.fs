open System

let blank x = new String(' ', String.length x)

let nextCarpet carpet =
  List.map (fun x -> x + x + x) carpet @
  List.map (fun x -> x + (blank x) + x) carpet @
  List.map (fun x -> x + x + x) carpet

let rec sierpinskiCarpet n =
  let rec aux n carpet =
    if n = 0 then carpet
             else aux (n-1) (nextCarpet carpet)
  aux n ["#"]

List.iter (printfn "%s") (sierpinskiCarpet 3)
