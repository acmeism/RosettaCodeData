module Main exposing ( main )

import Task exposing ( Task, succeed, perform, andThen )
import Html exposing (Html, div, text)
import Browser exposing ( element )
import Time exposing ( now, posixToMillis )

cLIMIT : Int
cLIMIT = 1000000

-- an infinite non-empty non-memoizing Co-Inductive Stream (CIS)...
type CIS a = CIS a (() -> CIS a)

uptoCIS2List : comparable -> CIS comparable -> List comparable
uptoCIS2List n cis =
  let loop (CIS hd tl) lst =
        if hd > n then List.reverse lst
        else loop (tl()) (hd :: lst)
  in loop cis []

countCISTo : comparable -> CIS comparable -> Int
countCISTo lmt cis =
  let cntem acc (CIS hd tlf) =
        if hd > lmt then acc else cntem (acc + 1) (tlf())
  in cntem 0 cis

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

type alias Model = ( Int, String, String )

type Msg = Start Int | Done ( Int, Int )

timemillis : () -> Task Never Int
timemillis() = now |> andThen (\ t -> succeed (posixToMillis t))

test : Int -> Cmd Msg
test lmt =
  let cnt = countCISTo lmt (primesPQ())
  in timemillis() |> andThen (\ t -> succeed ( t, cnt )) |> perform Done

myupdate : Msg -> Model -> (Model, Cmd Msg)
myupdate msg mdl =
  let (strttm, oldstr, _) = mdl in
  case msg of
    Start tm -> ( ( tm, oldstr, "Running..." ), test cLIMIT )
    Done (stptm, answr) ->
      ( ( stptm, oldstr, "Found " ++ String.fromInt answr ++
           " primes to " ++ String.fromInt cLIMIT ++
           " in " ++ String.fromInt (stptm - strttm) ++ " milliseconds." )
      , Cmd.none )

myview : Model -> Html msg
myview mdl =
  let (_, str1, str2) = mdl
  in div [] [ div [] [text str1], div [] [text str2] ]

main : Program () Model Msg
main =
  element { init = \ _ -> ( ( 0
                            , "The primes up to 100 are:  " ++
                                (primesPQ() |> uptoCIS2List 100
                                  |> List.map String.fromInt
                                  |> String.join ", ") ++ "."
                            , "" ), perform Start (timemillis()) )
          , update = myupdate
          , subscriptions = \ _ -> Sub.none
          , view = myview }
