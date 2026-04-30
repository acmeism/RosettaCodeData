let X q=not q
let mutable q = false
let mutable doors = []
for n in 1..100 do
  for g in 1..n do if n%g=0 then q<-X(q)
  if q then doors<-n::doors
  q<-false
printfn "%A" (doors|>List.rev)
