// Variadic fixed-point combinator. Nigel Galloway: March 15th., 2024
let h2 n = function 0->2 |g->   n (g-1)
let h1 n = function 0->1 |g->h2 n (g-1)
let h0 n = function 0->0 |g->h1 n (g-1)
let mod3 n=Y h0 n
[0..10] |> List.iter(mod3>>printf "%d "); printfn ""
