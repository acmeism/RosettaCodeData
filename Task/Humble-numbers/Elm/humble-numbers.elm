module Main exposing (main)

import Browser
import Html exposing (div, pre, text, br)
import Task exposing (Task, succeed, andThen, perform)
import BigInt
import Bitwise exposing (shiftRightBy, and)
import Time exposing (now, posixToMillis)

-- an infinite non-empty non-memoizing Co-Inductive Stream (CIS)...
type CIS a = CIS a (() -> CIS a)

takeCIS2String : Int -> (a -> String) -> CIS a -> String
takeCIS2String n cvtf cis =
  let loop i (CIS hd tl) lst =
        if i < 1 then List.reverse lst |> String.join ", "
        else loop (i - 1) (tl()) (cvtf hd :: lst)
  in loop n cis []

-- a Min Heap binary heap Priority Queue...
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

-- actual humble function implementation...
type alias Mults = { x2 : Int, x3 : Int, x5 : Int, x7 : Int }
type alias LogRep = { lg : Float, mlts : Mults }
oneLogRep : LogRep
oneLogRep = LogRep 0.0 <| Mults 0 0 0 0
lg10 : Float
lg10 = 1.0
lg7 : Float
lg7 = logBase 10 7
lg5 : Float
lg5 = logBase 10.0 5.0
lg3 : Float
lg3 = logBase 10.0 3.0
lg2 : Float
lg2 = lg10 - lg5
multLR2 : LogRep -> LogRep
multLR2 ({ lg, mlts } as lr) =
  { lr | lg = lg + lg2, mlts = { mlts | x2 = mlts.x2 + 1 } }
multLR3 : LogRep -> LogRep
multLR3 ({ lg, mlts } as lr) =
  { lr | lg = lg + lg3, mlts = { mlts | x3 = mlts.x3 + 1 } }
multLR5 : LogRep -> LogRep
multLR5 ({ lg, mlts } as lr) =
  { lr | lg = lg + lg5, mlts = { mlts | x5 = mlts.x5 + 1 } }
multLR7 : LogRep -> LogRep
multLR7 ({ lg, mlts } as lr) =
  { lr | lg = lg + lg7, mlts = { mlts | x7 = mlts.x7 + 1 } }
showLogRep : LogRep -> String
showLogRep lr =
  let xpnd x m r =
        if x <= 0 then r
        else xpnd (shiftRightBy 1 x) (BigInt.mul m m)
                  (if (and 1 x) /= 0 then BigInt.mul m r else r)
  in BigInt.fromInt 1 |> xpnd lr.mlts.x2 (BigInt.fromInt 2)
       |> xpnd lr.mlts.x3 (BigInt.fromInt 3) |> xpnd lr.mlts.x5 (BigInt.fromInt 5)
       |> xpnd lr.mlts.x7 (BigInt.fromInt 7) |> BigInt.toString

humblesLog : () -> CIS LogRep
humblesLog() =
  let prmfs = [multLR7, multLR5, multLR3, multLR2]
      fprmf = List.head prmfs |> Maybe.withDefault identity -- never Nothing!
      rstps = List.tail prmfs |> Maybe.withDefault [] -- never Nothing!
      frstcis =
        let nxt lr =
              CIS lr <| \ _ -> nxt (fprmf lr)
        in nxt (fprmf oneLogRep)
      dflt = (0.0, Mults 0 0 0 0)
      mkcis lrf cis =
        let frst = lrf oneLogRep
            scnd = lrf frst
            nxt pq (CIS hd tlf as cs) =
              let (lgv, v) = peekMinPQ pq |> Maybe.withDefault dflt in
              if lgv < hd.lg then let lr = (LogRep lgv v) in CIS lr <| \ _ ->
                   let { lg, mlts } = lrf lr
                   in nxt (replaceMinPQ lg mlts pq) cs
              else CIS hd <| \ _ ->
                     let { lg, mlts } = lrf hd
                     in nxt (pushPQ lg mlts pq) (tlf())
        in CIS frst <| \ _ -> nxt (pushPQ scnd.lg scnd.mlts emptyPQ) cis
      rest() = List.foldl mkcis frstcis rstps
  in CIS oneLogRep <| \ _ -> rest()

-- pretty printing function to add commas every 3 chars from left...
comma3 : String -> String
comma3 s =
  let go n lst =
        if n < 1 then String.join "," lst else
        let nn = max (n - 3) 0
        in go nn (String.slice nn n s :: lst)
  in go (String.length s) []

humbleDigitCountsTo : Int -> CIS LogRep -> List String
humbleDigitCountsTo n cis =
  let go i (CIS hd tlf) cnt cacc lst =
        if i >= n then List.reverse lst else
        if truncate hd.lg <= i then go i (tlf()) (cnt + 1) cacc lst
        else let ni = i + 1
                 ncacc = cacc + cnt
                 str =
                   (String.padLeft 4 ' ' << String.fromInt) ni
                   ++ (String.padLeft 14 ' ' << comma3 << String.fromInt) cnt
                   ++ (String.padLeft 19 ' ' << comma3 << String.fromInt) ncacc
          in go ni (tlf()) 1 ncacc (str :: lst) -- always > 1 per dgt
  in go 0 cis 0 0 []

-- code to do with testing...
timemillis : () -> Task Never Int -- a side effect function
timemillis() = now |> andThen (\ t -> succeed (posixToMillis t))

test : () -> Cmd Msg
test() =
  let numdgt = 100
      hdg1 = "The first 50 humble numbers are:  "
      msg1 = humblesLog() |> takeCIS2String 50 showLogRep
      hdg2 = "Count of humble numbers for each digit length 1-"
                ++ String.fromInt numdgt ++ ":"
      msg2 = "Digits       Count              Accum"
  in timemillis()
       |> Task.andThen (\ strt ->
            let rslt = humblesLog() |> humbleDigitCountsTo numdgt
            in timemillis()
              |> Task.andThen (\ stop ->
                   succeed (((hdg1 ++ msg1) :: "" :: hdg2 :: msg2 :: rslt)
                     ++ ["Counting took " ++ String.fromInt (stop - strt)
                        ++ " milliseconds."])))
  |> perform Done

-- following code has to do with outputting to a web page using MUV/TEA...
type alias Model = List String

type Msg = Done Model

main : Program () Model Msg
main = Browser.element
  { init = \ _ -> ([], test())
  , update = \ (Done mdl) _ -> (mdl, Cmd.none)
  , subscriptions = \ _ -> Sub.none
  , view = div [] << List.map (\ s ->
       if s == "" then br [] []
       else pre [] <| List.singleton <| text s)
  }
