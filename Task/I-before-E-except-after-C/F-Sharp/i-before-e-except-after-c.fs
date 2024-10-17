// I before E except after C. Nigel Galloway: September 30th., 2024
type plausibility=Plausible|Implausible
let fN n g=System.Text.RegularExpressions.Regex.Matches(n,g).Count
let fG n g=g|>Array.map2(fun n g->n+g)[|n("ie");n("ei");n("cie");n("cei")|]
let n=System.IO.File.ReadLines("unixdict.txt")|>Seq.fold(fun n g->fG (fN g) n)[|0;0;0;0|]
printfn($"I before E except after C is {if n[0]-n[2]>2*n[2] then Plausible else Implausible}")
printfn($"E before I except after C is {if n[1]-n[3]>2*n[3] then Plausible else Implausible}")
printfn($"I before E   when after C is {if n[2]>2*n[3] then Plausible else Implausible}")
printfn($"E before I   when after C is {if n[3]>2*n[2] then Plausible else Implausible}")
