type PriorityQ comparable v =
  Mt
  | Br comparable v (PriorityQ comparable v)
                    (PriorityQ comparable v)

emptyPQ : PriorityQ comparable v
emptyPQ = Mt

peekMinPQ : PriorityQ comparable v -> Maybe (comparable, v)
peekMinPQ  pq = case pq of
                  (Br k v _ _) -> Just (k, v)
                  Mt -> Nothing

pushPQ : comparable -> v -> PriorityQ comparable v
           -> PriorityQ comparable v
pushPQ wk wv pq =
  case pq of
    Mt -> Br wk wv Mt Mt
    (Br vk vv pl pr) ->
      if wk <= vk then Br wk wv (pushPQ vk vv pr) pl
      else Br vk vv (pushPQ wk wv pr) pl

siftdown : comparable -> v -> PriorityQ comparable v
             -> PriorityQ comparable v -> PriorityQ comparable v
siftdown wk wv pql pqr =
  case pql of
    Mt -> Br wk wv Mt Mt
    (Br vkl vvl pll prl) ->
      case pqr of
        Mt -> if wk <= vkl then Br wk wv pql Mt
              else Br vkl vvl (Br wk wv Mt Mt) Mt
        (Br vkr vvr plr prr) ->
          if wk <= vkl && wk <= vkr then Br wk wv pql pqr
          else if vkl <= vkr then Br vkl vvl (siftdown wk wv pll prl) pqr
               else Br vkr vvr pql (siftdown wk wv plr prr)

replaceMinPQ : comparable -> v -> PriorityQ comparable v
                 -> PriorityQ comparable v
replaceMinPQ wk wv pq = case pq of
                          Mt -> Mt
                          (Br _ _ pl pr) -> siftdown wk wv pl pr

primesPQ : () -> CIS Int
primesPQ() =
  let
    sieve n pq q (CIS bp bptl as bps) =
      if n >= q then
        let adv = bp + bp in let (CIS nbp _ as nbps) = bptl()
        in sieve (n + 2) (pushPQ (q + adv) adv pq) (nbp * nbp) nbps
      else let
             (nxtc, _) = peekMinPQ pq |> Maybe.withDefault (q, 0) -- default when empty
             adjust tpq =
               let (c, adv) = peekMinPQ tpq |> Maybe.withDefault (0, 0)
               in if c > n then tpq
                  else adjust (replaceMinPQ (c + adv) adv tpq)
           in if n >= nxtc then sieve (n + 2) (adjust pq) q bps
              else CIS n <| \ () -> sieve (n + 2) pq q bps
    oddprms() = CIS 3 <| \ () -> sieve 5 emptyPQ 9 <| oddprms()
  in CIS 2 <| \ () -> oddprms()
