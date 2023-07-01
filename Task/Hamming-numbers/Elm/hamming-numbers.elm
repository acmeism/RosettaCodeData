module Main exposing ( main )

import Bitwise exposing (..)
import BigInt
import Task exposing ( Task, succeed, perform, andThen )
import Html exposing ( div, text )
import Browser exposing ( element )
import Time exposing ( now, posixToMillis )

cLIMIT : Int
cLIMIT = 1000000

-- an infinite non-empty non-memoizing Co-Inductive Stream (CIS)...
type CIS a = CIS a (() -> CIS a)

takeCIS2List : Int -> CIS a -> List a
takeCIS2List n cis =
  let loop i (CIS hd tl) lst =
        if i < 1 then List.reverse lst
        else loop (i - 1) (tl()) (hd :: lst)
  in loop n cis []

nthCIS : Int -> CIS a -> a
nthCIS n (CIS hd tl) =
  if n <= 1 then hd else nthCIS (n - 1) (tl())

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

type alias Trival = (Int, Int, Int)
showTrival : Trival -> String
showTrival tv =
  let (x2, x3, x5) = tv
      xpnd x m r =
        if x <= 0 then r
        else xpnd (shiftRightBy 1 x) (BigInt.mul m m)
                  (if (and 1 x) /= 0 then BigInt.mul m r else r)
  in BigInt.fromInt 1 |> xpnd x2 (BigInt.fromInt 2)
       |> xpnd x3 (BigInt.fromInt 3) |> xpnd x5 (BigInt.fromInt 5)
       |> BigInt.toString

type alias LogRep = { lr: Float, trv: Trival }
ltLogRep : LogRep -> LogRep -> Bool
ltLogRep lra lrb = lra.lr < lrb.lr
oneLogRep : LogRep
oneLogRep = { lr = 0.0, trv = (0, 0, 0) }
lg2_2 : Float
lg2_2 = 1.0 -- log base two of two
lg2_3 : Float
lg2_3 = logBase 2.0 3.0
lg2_5 : Float
lg2_5 = logBase 2.0 5.0
multLR2 : LogRep -> LogRep
multLR2 lr = let (x2, x3, x5) = lr.trv
             in LogRep (lr.lr + lg2_2) (x2 + 1, x3, x5)
multLR3 : LogRep -> LogRep
multLR3 lr = let (x2, x3, x5) = lr.trv
             in LogRep (lr.lr + lg2_3) (x2, x3 + 1, x5)
multLR5 : LogRep -> LogRep
multLR5 lr = let (x2, x3, x5) = lr.trv
             in LogRep (lr.lr + lg2_5) (x2, x3, x5 + 1)

hammingsLog : () -> CIS Trival
hammingsLog() =
  let im235 = multLR2 oneLogRep
      im35 = multLR3 oneLogRep
      imrg = im35
      im5 = multLR5 oneLogRep
      next bpq mpq m235 mrg m35 m5 =
        if ltLogRep m235 mrg then
          let omin = case peekMinPQ bpq of
                       Just (lr, trv) -> LogRep lr trv
                       Nothing -> m235 -- at the beginning!
              nm235 = multLR2 omin
              nbpq = replaceMinPQ m235.lr m235.trv bpq
          in CIS m235.trv <| \ () ->
               next nbpq mpq nm235 mrg m35 m5
        else
          if ltLogRep mrg m5 then
            let omin = case peekMinPQ mpq of
                         Just (lr, trv) -> LogRep lr trv
                         Nothing -> mrg -- at the beginning!
                nm35 = multLR3 omin
                nmrg = if ltLogRep nm35 m5 then nm35 else m5
                nmpq = replaceMinPQ mrg.lr mrg.trv mpq
                nbpq = pushPQ mrg.lr mrg.trv bpq
            in CIS mrg.trv <| \ () ->
                 next nbpq nmpq m235 nmrg nm35 m5
          else
            let nm5 = multLR5 m5
                nmrg = if ltLogRep m35 nm5 then m35 else nm5
                nmpq = pushPQ m5.lr m5.trv mpq
                nbpq = pushPQ m5.lr m5.trv bpq
            in CIS m5.trv <| \ () ->
                 next nbpq nmpq m235 nmrg m35 nm5
  in CIS (0, 0, 0) <| \ () ->
       next emptyPQ emptyPQ im235 imrg im35 im5

timemillis : () -> Task Never Int -- a side effect function
timemillis() = now |> andThen (\ t -> succeed (posixToMillis t))

test : Int -> Cmd Msg -- side effect function chain (includes "perform")...
test lmt =
  let msg1 = "The first 20 Hamming numbers are:  " ++
                (hammingsLog() |> takeCIS2List 20
                               |> List.map showTrival
                               |> String.join ", ") ++ "."
      msg2 = "The 1691st Hamming number is " ++
                (hammingsLog() |> nthCIS 1691
                               |> showTrival) ++ "."
      msg3 = "The " ++ String.fromInt cLIMIT ++ "th Hamming number is:"
  in timemillis()
    |> andThen (\ strt ->
       let rsltstr = hammingsLog() |> nthCIS lmt
                                   |> showTrival in
       timemillis()
         |> andThen (\ stop ->
              succeed [msg1, msg2, msg3, rsltstr ++ " in "
                         ++ String.fromInt (stop - strt)
                         ++ " milliseconds."]))
    |> perform Done

-- following code has to do with outputting to a web page using MUV/TEA...

type alias Model = List String

type Msg = Done Model

main : Program () Model Msg
main = -- starts with empty list of strings; views model of filled list...
  element { init = \ _ -> ( [], test cLIMIT )
          , update = \ (Done mdl) _ -> ( mdl , Cmd.none )
          , subscriptions = \ _ -> Sub.none
          , view = div [] << List.map (div [] << List.singleton << text) }
