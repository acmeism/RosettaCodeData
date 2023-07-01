// Verhoeff algorithm. Nigel Galloway: August 26th., 2021
let d,inv,p=let d=[|0;1;2;3;4;5;6;7;8;9;1;2;3;4;0;6;7;8;9;5;2;3;4;0;1;7;8;9;5;6;3;4;0;1;2;8;9;5;6;7;4;0;1;2;3;9;5;6;7;8;5;9;8;7;6;0;4;3;2;1;6;5;9;8;7;1;0;4;3;2;7;6;5;9;8;2;1;0;4;3;8;7;6;5;9;3;2;1;0;4;9;8;7;6;5;4;3;2;1;0|]
            let p=[|0;1;2;3;4;5;6;7;8;9;1;5;7;6;2;8;3;0;9;4;5;8;0;3;7;9;6;1;4;2;8;9;1;6;0;4;3;5;2;7;9;4;5;3;1;2;6;8;7;0;4;2;8;6;5;7;3;9;0;1;2;7;9;3;8;0;6;4;1;5;7;0;4;6;9;1;3;2;5;8|]
            let inv=[|0;4;3;2;1;5;6;7;8;9|] in (fun n g->d.[10*n+g]),(fun g->inv.[g]),(fun n g->p.[10*(n%8)+g])
let fN g=Seq.unfold(fun(i,g,l)->if i=0I then None else let ni=int(i%10I) in let l=d l (p g ni) in Some((ni,l),(i/10I,g+1,l)))(g,0,0)
let csum g=let _,g=Seq.last(fN g) in inv g
let printTable g=printfn $"Work Table for %A{g}\n i  nᵢ  p[i,nᵢ] c\n--------------"; fN g|>Seq.iteri(fun i (n,g)->printfn $"%d{i}  %d{n}      %d{p i n}    %d{g}")
printTable 2360I
printfn $"\nThe CheckDigit for 236 is %d{csum 2360I}\n"
printTable 2363I
printfn $"\nThe assertion that 2363 is valid is %A{csum 2363I=0}\n"
printTable 2369I
printfn $"\nThe assertion that 2369 is valid is %A{csum 2369I=0}\n"
printTable 123450I
printfn $"\nThe CheckDigit for 12345 is %d{csum 123450I}\n"
printTable 123451I
printfn $"\nThe assertion that 123451 is valid is %A{csum 123451I=0}\n"
printTable 123459I
printfn $"\nThe assertion that 123459 is valid is %A{csum 123459I=0}"
printfn $"The CheckDigit for 123456789012 is %d{csum 1234567890120I}"
printfn $"The assertion that 1234567890120 is valid is %A{csum 1234567890120I=0}"
printfn $"The assertion that 1234567890129 is valid is %A{csum 1234567890129I=0}"
