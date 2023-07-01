// Loops/Break. Nigel Galloway: February 21st., 2022
let n=System.Random()
let rec fN g=printf "%d " g; if g <> 10 then fN(n.Next(20))
fN(n.Next(20))
