// Alternade words: Nigel Galloway. June 10th., 2021
let dict=seq{use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()}|>Seq.filter(fun n->n.Length>2)|>List.ofSeq
let fN g=let n=Seq.foldBack2(fun n g (z:char list [])->z.[g]<-n::z.[g]; z) g (let rec fN()=seq{yield![0;1]; yield! fN()} in fN())([|[];[]|]) in (n.[0],n.[1])
let fG(n,g)=let fN g=(Array.ofList>>System.String) g in let n,g=fN n,fN g in if List.contains n dict && List.contains g dict then Some(n,g) else None
dict|>Seq.filter(fun n->n.Length>5)|>Seq.iter(fun n->match (fN>>fG) n with Some(g,l)->printfn "%s -> %s * %s" n g l |_->())
