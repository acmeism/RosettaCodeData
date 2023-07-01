// Variable declaration reset. Nigel Galloway: June 21st 2022
let s=[1;2;2;3;4;4;5]
// First let me write this in real F#, which rather avoids the whole issue
printfn "Real F#"
s|>List.pairwise|>List.iteri(fun i (n,g)->if n=g then printfn "%d" (i+1))
// Now let me take the opportunity to write some awful F# by translating the C++
printfn "C++ like awful F#"
let mutable previousValue = -1
for i in 0..s.Length-1 do
  let currentValue=s.[i]
  if previousValue = currentValue then printfn "%d" i
  previousValue <- currentValue
