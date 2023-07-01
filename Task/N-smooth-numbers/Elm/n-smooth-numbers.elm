module Main exposing ( main )

import Bitwise exposing (..)
import BigInt exposing ( BigInt )
import Task exposing ( Task, succeed, perform, andThen )
import Html exposing ( div, text, br )
import Browser exposing ( element )
import Time exposing ( now, posixToMillis )

-- an infinite non-empty non-memoizing Co-Inductive Stream (CIS)...
type CIS a = CIS a (() -> CIS a)

takeCIS2String : Int -> (a -> String) -> CIS a -> String
takeCIS2String n cnvf (CIS ohd otlf) =
  let loop i (CIS hd tl) str =
        if i < 1 then str
        else loop (i - 1) (tl()) (str ++ ", " ++ cnvf hd)
  in loop (n - 1) (otlf()) (cnvf ohd)

dropCIS : Int -> CIS a -> CIS a
dropCIS n (CIS _ tl as cis) =
  if n < 1 then cis else dropCIS (n - 1) (tl())


-- Priority Queue definition...
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

primesTo : Int -> List Int
primesTo n =
  if n < 3 then if n < 2 then [] else [2] else
  let oddPrimesTo on =
        let sqrtlmt = toFloat on |> sqrt |> truncate
            obps = if sqrtlmt < 3 then [] else oddPrimesTo sqrtlmt
            ns = List.range 0 ((on - 3) // 2) -- [ 3 .. 2 .. on ]
                   |> List.map ((+) 3 << (*) 2)
            filtfnc fn = List.all (\ bp -> bp * bp > fn ||
                                            modBy bp fn /= 0) obps
        in List.filter filtfnc ns
  in 2 :: oddPrimesTo n

smooths : Int -> CIS BigInt
smooths n =
  let infcis v = CIS v <| \ _ -> infcis (BigInt.add v (BigInt.fromInt 1))
      dflt = (0.0, BigInt.fromInt 1) in
  if n < 2 then infcis (BigInt.fromInt 1) else
  let prms = primesTo n |> List.reverse
               |> List.map (\ p -> (logBase 2 (toFloat p), BigInt.fromInt p))
      ((lgfrstp, frstp) as frstpr) = List.head prms |> Maybe.withDefault dflt
      rstps = List.tail prms |> Maybe.withDefault []
      frstcis =
        let nxt ((lg, v) as vpr) =
              CIS vpr <| \ _ -> nxt (lg + lgfrstp, BigInt.mul v frstp)
        in nxt frstpr
      mkcis ((lg, p) as pr) cis =
        let nxt pq (CIS ((lghd, hd) as hdpr) tlf as cs) =
              let ((lgv, v) as vpr) = peekMinPQ pq |> Maybe.withDefault dflt in
              if BigInt.lt v hd then CIS vpr <| \ _ ->
                   nxt (replaceMinPQ (lgv + lg) (BigInt.mul v p) pq) cs
              else CIS hdpr <| \ _ ->
                     nxt (pushPQ (lghd + lg) (BigInt.mul hd p) pq) (tlf())
        in CIS pr <| \ _ -> nxt (pushPQ (lg + lg) (BigInt.mul p p) emptyPQ) cis
      rest() = List.foldl mkcis frstcis rstps
      unpr (CIS (_, hd) tlf) = CIS hd <| \ _ -> unpr (tlf())
  in CIS (BigInt.fromInt 1) <| \ _ -> unpr (rest())

timemillis : () -> Task Never Int -- a side effect function
timemillis() = now |> andThen (\ t -> succeed (posixToMillis t))

test : () -> Cmd Msg -- side effect function chain (includes "perform")...
test() =
  timemillis()
    |> andThen (\ strt ->
       let test1 = primesTo 29 |> List.map ( \ p ->
                   [ "The first 25 " ++ String.fromInt p ++ "-smooths:"
                   , smooths p |> takeCIS2String 25 BigInt.toString
                   , "" ])
           test2 = primesTo 29 |> List.drop 1 |> List.map ( \ p ->
                   [ "The first three from the 3,000th "
                        ++ String.fromInt p ++ "-smooth numbers are:"
                   , smooths p |> dropCIS 2999
                               |> takeCIS2String 3 BigInt.toString
                   , "" ])
           test3 = primesTo 521 |> List.filter ((<=) 503) |> List.map ( \ p ->
                   [ "The first 20 30,000th up "
                        ++ String.fromInt p ++ "-smooth numbers are:"
                   , smooths p |> dropCIS 29999
                               |> takeCIS2String 20 BigInt.toString
                   , "" ])
       in timemillis()
         |> andThen (\ stop ->
              succeed ([test1, test2, test3, [[ "This took "
                         ++ String.fromInt (stop - strt)
                         ++ " milliseconds."]]]
                           |> List.concat |> List.concat)))
    |> perform Done

-- following code has to do with outputting to a web page using MUV/TEA...
type alias Model = List String

type Msg = Done Model

main : Program () Model Msg
main = -- starts with empty list of strings; views model of filled list...
  element { init = \ _ -> ( [], test() )
          , update = \ (Done mdl) _ -> ( mdl , Cmd.none )
          , subscriptions = \ _ -> Sub.none
          , view = \ mdl ->
              div [] <| List.map (\ s ->
                if s == "" then br [] []
                else div [] <| List.singleton <| text s) mdl
          }
