// Generate emirps. Nigel Galloway: March 25th., 2021
let N=seq{1..0x0FFFFFFF}|>Seq.map(fun n->((*)n>>string)n)|>Seq.cache
let G=let fG n g=n|>Seq.map(fun n->N|>Seq.find(fun i->i.[0..g]=string n)) in seq{yield! fG(seq{1..9}) 0; yield! fG(seq{10..49}) 1}
G|>Seq.iter(printf "%s "); printfn ""
