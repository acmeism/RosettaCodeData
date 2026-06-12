// Odd words: Nigel Galloway. June 9th., 2021
let dict=seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(fun n->n.Length>4)|>List.ofSeq
let fN g=let n=g|>String.mapi(fun n g->if n%2=0 then g else ' ')|>String.filter((<>)' ') in match List.contains n dict with true->Some(n,g) |_->None
dict|>Seq.filter(fun n->n.Length>6)|>Seq.choose fN|>Seq.iter(fun(n,g)->printfn "%s -> %s" g n)
