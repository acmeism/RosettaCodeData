module Main exposing (main)

import Browser exposing (element)
import Task exposing (Task, succeed, perform, andThen)
import Html exposing (Html, div, text)
import Time exposing (now, posixToMillis)

cLIMIT : Int
cLIMIT = 1000000

type CIS a = CIS a (() -> CIS a)

uptoCIS2List : comparable -> CIS comparable -> List comparable
uptoCIS2List n cis =
  let loop (CIS hd tl) lst =
        if hd > n then List.reverse lst
        else loop (tl()) (hd :: lst)
  in loop cis []

countCISTo : comparable -> CIS comparable -> Int
countCISTo n cis =
  let loop (CIS hd tl) cnt =
        if hd > n then cnt else loop (tl()) (cnt + 1)
  in loop cis 0

primesTreeFolding : () -> CIS Int
primesTreeFolding() =
  let
    merge (CIS x xtl as xs) (CIS y ytl as ys) =
      case compare x y of
        LT -> CIS x <| \ () -> merge (xtl()) ys
        EQ -> CIS x <| \ () -> merge (xtl()) (ytl())
        GT -> CIS y <| \ () -> merge xs (ytl())
    pmult bp =
      let adv = bp + bp
          pmlt p = CIS p <| \ () -> pmlt (p + adv)
      in pmlt (bp * bp)
    allmlts (CIS bp bptl) =
      CIS (pmult bp) <| \ () -> allmlts (bptl())
    pairs (CIS frst tls) =
      let (CIS scnd tlss) = tls()
      in CIS (merge frst scnd) <| \ () -> pairs (tlss())
    cmpsts (CIS (CIS hd tl) tls) =
      CIS hd <| \ () -> merge (tl()) <| cmpsts <| pairs (tls())
    testprm n (CIS hd tl as cs) =
      if n < hd then CIS n <| \ () -> testprm (n + 2) cs
      else testprm (n + 2) (tl())
    oddprms() =
      CIS 3 <| \ () -> testprm 5 <| cmpsts <| allmlts <| oddprms()
  in CIS 2 <| \ () -> oddprms()

type alias Model = List String

type alias Msg = Model

test : (() -> CIS Int) -> Int -> Cmd Msg
test primesf lmt =
  let
    to100 = primesf() |> uptoCIS2List 100
              |> List.map String.fromInt |> String.join ", "
    to100str = "The primes to 100 are:  " ++ to100
    timemillis() = now |> andThen (succeed << posixToMillis)
  in timemillis() |> andThen (\ strt ->
       let cnt = primesf() |> countCISTo lmt
       in timemillis() |> andThen (\ stop ->
         let answrstr = "Found " ++ (String.fromInt cnt) ++ " primes to "
                          ++ (String.fromInt cLIMIT) ++ " in "
                          ++ (String.fromInt (stop - strt)) ++ " milliseconds."
         in succeed [to100str, answrstr] ) ) |> perform identity

main : Program () Model Msg
main =
  element { init = \ _ -> ( [], test primesTreeFolding cLIMIT )
          , update = \ msg _ -> (msg, Cmd.none)
          , subscriptions = \ _ -> Sub.none
          , view = div [] << List.map (div [] << List.singleton << text) }
