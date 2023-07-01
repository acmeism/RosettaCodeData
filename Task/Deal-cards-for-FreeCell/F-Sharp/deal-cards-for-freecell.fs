let msKindaRand seed =
  let state = ref seed
  (fun (_:unit) ->
      state := (214013 * !state + 2531011) &&& System.Int32.MaxValue
      !state / (1<<<16))

let unshuffledDeck = [0..51] |> List.map(fun n->sprintf "%c%c" "A23456789TJQK".[n / 4] "CDHS".[n % 4])

let deal boot idx =
  let (last,rest) = boot |> List.rev |> fun xs->(List.head xs),(xs |> List.tail |> List.rev)
  if idx=((List.length boot) - 1) then last, rest
  else
    rest
    |> List.mapi (fun i x -> i,x)
    |> List.partition (fst >> ((>) idx))
    |> fun (xs,ys) -> (List.map snd xs),(List.map snd ys)
    |> fun (xs,ys) -> (List.head ys),(xs @ last::(List.tail ys))

let game gameNo =
  let rnd = msKindaRand gameNo
  [52..-1..1]
  |> List.map (fun i->rnd() % i)
  |> List.fold (fun (dealt, boot) idx->deal boot idx |> fun (x,xs) -> (x::dealt, xs)) ([],unshuffledDeck)
  |> fst |> List.rev
  |> List.chunkBySize 8
  |> List.map (String.concat " ")
  |> String.concat "\n"
  |> printfn "Game #%d\n%s\n" gameNo


[1; 617] |> List.iter game
