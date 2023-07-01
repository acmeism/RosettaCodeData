// integration methods
let left f dx x = f x * dx
let right f dx x = f (x + dx) * dx
let mid f dx x = f (x + dx / 2.0) * dx
let trapez f dx x = (f x + f (x + dx)) * dx / 2.0
let simpson f dx x = (f x + 4.0 * f (x + dx / 2.0) + f (x + dx)) * dx / 6.0

// common integration function
let integrate a b f n method =
    let dx = (b - a) / float n
    [0..n-1] |> Seq.map (fun i -> a + float i * dx) |> Seq.sumBy (method f dx)

// test cases
let methods = [ left; right; mid; trapez; simpson ]
let cases = [
    (fun x -> x * x * x), 0.0, 1.0,    100
    (fun x -> 1.0 / x),   1.0, 100.0,  1000
    (fun x -> x),         0.0, 5000.0, 5000000
    (fun x -> x),         0.0, 6000.0, 6000000
]

// execute and output
Seq.allPairs cases methods
|> Seq.map (fun ((f, a, b, n), method) -> integrate a b f n method)
|> Seq.iter (printfn "%f")
