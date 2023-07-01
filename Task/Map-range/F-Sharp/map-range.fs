let map (a1: float) (a2: float) (b1: float) (b2: float) (s: float): float =
    b1 + (s - a1) * (b2 - b1) / (a2 - a1)

let xs = [| for i in 0..10 -> map 0.0 10.0 -1.0 0.0 (float i) |]

for x in xs do printfn "%f" x
