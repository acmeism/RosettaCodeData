type Card = int * int

type Cards = Card list

let joker = (69,69)

let rankInvalid = "invalid", 99

let allCards = {0..12} |> Seq.collect (fun x->({0..3} |> Seq.map (fun y->x,y)))

let allSame = function | y::ys -> List.forall ((=) y) ys | _-> false

let straightList (xs:int list) = xs |> List.sort |> List.mapi (fun i n->n - i) |> allSame

let cardList (s:string): Cards =
  s.Split() |> Seq.map (fun s->s.ToLower())
  |> Seq.map (fun s ->
    if s="joker" then joker
    else
      match (s |> List.ofSeq) with
      | '1'::'0'::xs -> (9, xs) | '!'::xs -> (-1, xs) | x::xs-> ("a23456789!jqk".IndexOf(x), xs) | _  as xs-> (-1, xs)
      |> function | -1, _  -> (-1, '!') | x, y::[] -> (x, y) | _  -> (-1, '!')
      |> function
      | x, 'h' | x, '♥' -> (x, 0) | x, 'd' | x, '♦' -> (x, 1) | x, 'c' | x, '♣' -> (x, 2)
      | x, 's' | x, '♠' -> (x, 3) | _ -> (-1, -1)
    )
  |> Seq.filter (fst >> ((<>) -1)) |> List.ofSeq


let rank (cards: Cards) =
  if cards.Length<>5 then rankInvalid
  else
    let cts = cards |> Seq.groupBy fst |> Seq.map (snd >> Seq.length) |> List.ofSeq |> List.sort |> List.rev
    if cts.[0]=5 then ("five-of-a-kind", 1)
    else
      let flush = cards |> List.map snd |> allSame
      let straight =
        let (ACE, ALT_ACE) = 0, 13
        let faces = cards |> List.map fst |> List.sort
        (straightList faces) || (if faces.Head<>ACE then false else (straightList (ALT_ACE::(faces.Tail))))
      if straight && flush then ("straight-flush", 2)
      else
        let cts = cards |> Seq.groupBy fst |> Seq.map (snd >> Seq.length) |> List.ofSeq |> List.sort |> List.rev
        if cts.[0]=4 then ("four-of-a-kind", 3)
        elif cts.[0]=3 && cts.[1]=2 then ("full-house", 4)
        elif flush then ("flush", 5)
        elif straight then ("straight", 6)
        elif cts.[0]=3 then ("three-of-a-kind", 7)
        elif cts.[0]=2 && cts.[1]=2 then ("two-pair", 8)
        elif cts.[0]=2 then ("one-pair", 9)
        else ("high-card", 10)

let pickBest (xs: seq<Cards>) =
  let cmp a b = (<) (snd a) (snd b)
  let pick currentBest x = if (cmp (snd x) (snd currentBest)) then x else currentBest
  xs |> Seq.map (fun x->x, (rank x)) |> Seq.fold pick ([], rankInvalid)

let calcHandRank handStr =
  let cards = handStr |> cardList
  if cards.Length<>5
    then (cards, rankInvalid)
    else
      cards |> List.partition ((=) joker) |> fun (x,y) -> x.Length, y
      |> function
      | (0,xs) when (xs |> Seq.distinct |> Seq.length)=5 -> xs, (rank xs)
      | (1,xs) -> allCards |> Seq.map (fun x->x::xs) |> pickBest
      | (2,xs) -> allCards |> Seq.collect (fun x->allCards |> Seq.map (fun y->y::x::xs)) |> pickBest
      | _ -> cards, rankInvalid


let showHandRank handStr =
  // handStr |> calcHandRank |> fun (cards, (rankName,_)) -> printfn "%s: %A %s" handStr cards rankName
  handStr |> calcHandRank |> (snd >> fst) |> printfn "%s: %s" handStr

[
"2♥ 2♦ 2♣ k♣ q♦"
"2♥ 5♥ 7♦ 8♣ 9♠"
"a♥ 2♦ 3♣ 4♣ 5♦"
"2♥ 3♥ 2♦ 3♣ 3♦"
"2♥ 7♥ 2♦ 3♣ 3♦"
"2♥ 7♥ 7♦ 7♣ 7♠"
"10♥ j♥ q♥ k♥ a♥"
"4♥ 4♠ k♠ 5♦ 10♠"
"q♣ 10♣ 7♣ 6♣ 4♣"
"joker  2♦  2♠  k♠  q♦"
"joker  5♥  7♦  8♠  9♦"
"joker  2♦  3♠  4♠  5♠"
"joker  3♥  2♦  3♠  3♦"
"joker  7♥  2♦  3♠  3♦"
"joker  7♥  7♦  7♠  7♣"
"joker  j♥  q♥  k♥  A♥"
"joker  4♣  k♣  5♦ 10♠"
"joker  k♣  7♣  6♣  4♣"
"joker  2♦  joker  4♠  5♠"
"joker  Q♦  joker  A♠ 10♠"
"joker  Q♦  joker  A♦ 10♦"
"joker  2♦  2♠  joker  q♦"
]
|> List.iter showHandRank
