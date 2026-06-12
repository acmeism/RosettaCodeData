// Words from neighbour ones. Nigel Galloway: February 11th., 2021.
let g=[|use n=System.IO.File.OpenText("unixdict.txt") in while not n.EndOfStream do yield n.ReadLine()|]|>Array.filter(fun n->n.Length>8)
g|>Array.windowed 9|>Array.map(fun n->n|>Array.mapi(fun n g->g.[n])|>System.String)|>Array.filter(fun n-> Array.contains n g)|>Array.distinct|>Array.iter(printfn "%s")
