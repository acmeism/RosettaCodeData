type frac = Microsoft.FSharp.Math.BigRational

let perf n = 1N = List.fold (+) 0N (List.map (fun i -> if n % i = 0 then 1N/frac.FromInt(i) else 0N) [2..n])

for i in 1..(1<<<19) do if (perf i) then printfn "%i is perfect" i
