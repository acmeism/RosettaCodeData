let xss = Seq.groupBy (Array.ofSeq >> Array.sort) (System.IO.File.ReadAllLines "unixdict.txt")
Seq.map snd xss |> Seq.filter (Seq.length >> ( = ) (Seq.map (snd >> Seq.length) xss |> Seq.max))
