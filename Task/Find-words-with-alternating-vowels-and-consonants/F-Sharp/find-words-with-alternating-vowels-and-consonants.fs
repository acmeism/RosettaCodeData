// Find words with alternating vowels and consonants. Nigel Galloway: January 20th., 2020
let vowels=set['a';'e';'i';'o';'u']
let fN g=let rec fN g=function h::t->(if g<>vowels.Contains h then fN (not g) t else false)|_->true
         fN (vowels.Contains(Seq.head g)) (Seq.tail g|>List.ofSeq)
seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}
  |>Seq.filter(fun g->g.Length>9 && fN g)|>Seq.iter(printfn "%s")
