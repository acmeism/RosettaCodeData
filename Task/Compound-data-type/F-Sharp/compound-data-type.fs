type Point = { x : int; y : int }

let points = [
    {x = 1; y = 1};
    {x = 5; y = 5} ]

Seq.iter (fun p -> printfn "%d,%d" p.x p.y) points
