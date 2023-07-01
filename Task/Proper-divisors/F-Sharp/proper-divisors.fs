// the simple function with the answer
let propDivs n = [1..n/2] |> List.filter (fun x->n % x = 0)

// to cache the result length; helpful for a long search
let propDivDat n = propDivs n |> fun xs -> n, xs.Length, xs

// UI: always the longest and messiest
let show (n,count,divs) =
  let showCount = count |> function | 0-> "no proper divisors" | 1->"1 proper divisor" | _-> sprintf "%d proper divisors" count
  let showDiv = divs |> function | []->"" | x::[]->sprintf ": %d" x | _->divs |> Seq.map string |> String.concat "," |> sprintf ": %s"
  printfn "%d has %s%s" n showCount showDiv

// generate output
[1..10] |> List.iter (propDivDat >> show)

// use a sequence: we don't really need to hold this data, just iterate over it
Seq.init 20000 ( ((+) 1) >> propDivDat)
|> Seq.fold (fun a b ->match a,b with | (_,c1,_),(_,c2,_) when c2 > c1 -> b | _-> a) (0,0,[])
|> fun (n,count,_) -> (n,count,[]) |> show
