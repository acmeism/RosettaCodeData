let rec loop n =
  printfn "%d " n
  if (n+1)%6 > 0 then loop (n+1)
loop 0
