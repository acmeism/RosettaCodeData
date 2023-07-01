type N = |Price of float|Name of string|Year of int|Colour of string
let n=Map<string,N>[("name",Name("Rocket Skates"));("price",Price(12.75));("colour",Colour("yellow"))]
let g=Map<string,N>[("price",Price(15.25));("colour",Colour("red"));("year",Year(1974))]
let ng=(Map.toList n)@(Map.toList g)|>Map.ofList
printfn "%A" ng
