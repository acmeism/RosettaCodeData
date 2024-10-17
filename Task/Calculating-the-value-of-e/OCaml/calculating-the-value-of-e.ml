let n = 0x1p52

let e = (1. /. n +. 1.) ** n

let () = Printf.printf "%.15f (%B)\n" e (exp(1.) = e)
