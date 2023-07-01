//Integer Exponentiation, more interesting anyway than repeated multiplication. Nigel Galloway, October 12th., 2018
let rec myExp n g=match g with
                  |0            ->1
                  |g when g%2=1 ->n*(myExp n (g-1))
                  |_            ->let p=myExp n (g/2) in p*p

printfn "%d" (myExp 3 15)
