let rec f a=
if (a*a) mod 1000000 != 269696
then f(a+1)
else a
in
let a= f 1 in
Printf.printf "smallest positive integer whose square ends in the digits 269696 is %d\n" a
