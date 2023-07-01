//Jacobi Symbol. Nigel Galloway: July 14th., 2020
let J n m=let rec J n m g=match n with
                           0->if m=1 then g else 0
                          |n when n%2=0->J(n/2) m (if m%8=3 || m%8=5 then -g else g)
                          |n->J (m%n) n (if m%4=3 && n%4=3 then -g else g)
          J (n%m) m 1
printfn "n\m   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30\n     ----------------------------------------------------------------------------------------------------------------------"
[1..2..29]|>List.iter(fun m->printf "%3d" m; [1..30]|>List.iter(fun n->printf "%4d" (J n m)); printfn "")
