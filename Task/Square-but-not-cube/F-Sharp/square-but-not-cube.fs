let rec fN n g φ=if φ<31 then match compare(n*n)(g*g*g) with | -1->printfn "%d"(n*n);fN(n+1) g (φ+1)
                                                             |  0->printfn "%d cube and square"(n*n);fN(n+1)(g+1)φ
                                                             |  1->fN n (g+1) φ
fN 1 1 1
