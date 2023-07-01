let perf n = n = List.fold (+) 0 (List.filter (fun i -> n % i = 0) [1..(n-1)])

for i in 1..10000 do if (perf i) then printfn "%i is perfect" i
