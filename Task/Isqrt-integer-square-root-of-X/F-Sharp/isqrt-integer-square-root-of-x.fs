// Find Integer Floor sqrt of a Large Integer. Nigel Galloway: July 17th., 2020
let Isqrt n=let rec fN i g l=match(l>0I,i-g-l) with
                              (true,e) when e>=0I->fN e (g/2I+l) (l/4I)
                             |(true,_)           ->fN i (g/2I)   (l/4I)
                             |_                  ->g
            fN n 0I (let rec fG g=if g>n then g/4I else fG (g*4I) in fG 1I)
[0I..65I]|>Seq.iter(Isqrt>>string>>printf "%s "); printfn "\n"
let fN n=7I**n in [1..2..73]|>Seq.iter(fN>>Isqrt>>printfn "%a" (fun n g -> n.Write("{0:#,#}", g)))
