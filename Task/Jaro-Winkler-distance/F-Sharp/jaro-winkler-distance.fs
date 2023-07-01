// Calculate Jaro-Winkler Similarity of 2 Strings. Nigel Galloway: August 7th., 2020
let Jw P n g=let L=float(let i=Seq.map2(fun n g->n=g) n g in (if Seq.length i>4 then i|>Seq.take 4 else i)|>Seq.takeWhile id|>Seq.length)
             let J=J n g in J+P*L*(1.0-J)

let dict=System.IO.File.ReadAllLines("linuxwords.txt")
let fN g=let N=Jw 0.1 g in dict|>Array.map(fun n->(n,1.0-(N n)))|>Array.sortBy snd
["accomodate";"definately";"goverment";"occured";"publically";"recieve";"seperate";"untill";"wich"]|>
  List.iter(fun n->printfn "%s" n;fN n|>Array.take 5|>Array.iter(fun n->printf "%A" n);printfn "\n")
