let x = 2.0
let xi = 0.5
let y = 4.0
let yi = 0.25
let z = x + y
let zi = 1.0 / ( x + y )
let multiplier (n1,n2) = fun (m:float) -> n1 * n2 * m

[x; y; z]
|> List.zip [xi; yi; zi]
|> List.map multiplier
|> List.map ((|>) 0.5)
|> printfn "%A"
