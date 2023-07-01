//Naïve solution of Narcissitic number: Nigel Galloway - Febryary 18th., 2015
open System
let rec _Digits (n,g) = if n < 10 then n::g else _Digits(n/10,n%10::g)

seq{0 .. Int32.MaxValue} |> Seq.filter (fun n ->
  let d = _Digits (n, [])
  d |> List.fold (fun a l -> a + int ((float l) ** (float (List.length d)))) 0 = n) |> Seq.take(25) |> Seq.iter (printfn "%A")
