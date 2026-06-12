// Sum of cubes: Nigel Galloway. May 20th., 2021
let fN g=g*g*g in Seq.initInfinite((+)1>>fN)|>Seq.take 49|>Seq.scan((+))(0)|>Seq.iter(printf "%d "); printfn ""
