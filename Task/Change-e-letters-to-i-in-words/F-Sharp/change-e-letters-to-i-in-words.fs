// Change 'e' to 'i' in words. Nigel Galloway: February 18th., 2021
let g=[|use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()|]|>Array.filter(fun n->n.Length>5)
let fN g=(g,(Seq.map(fun n->if n='e' then 'i' else n)>>Array.ofSeq>>System.String)g)
g|>Array.filter(Seq.contains 'e')|>Array.map fN|>Array.filter(fun(_,n)-> Array.contains n g)|>Array.iter(fun(n,g)->printfn "%s ->  %s" n g)
