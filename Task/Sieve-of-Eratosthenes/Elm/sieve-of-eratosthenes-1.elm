module Main exposing (main)

import Browser exposing (element)
import Task exposing (Task, succeed, perform, andThen)
import Html exposing (Html, div, text)
import Time exposing (now, posixToMillis)

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

type alias Model = ( Int, String, String )

type Msg = Start Int | Done ( Int, Int )

cLIMIT : Int
cLIMIT = 1000000

timemillis : () -> Task Never Int
timemillis() = now |> andThen (\ t -> succeed (posixToMillis t))

test : Int -> Cmd Msg
test lmt =
  let cnt = countCISTo lmt (primesTreeFolding()) -- (soeDict())
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
                                (primesTreeFolding() |> uptoCIS2List 100
                                  |> List.map String.fromInt
                                  |> String.join ", ") ++ "."
                            , "" ), perform Start (timemillis()) )
          , update = myupdate
          , subscriptions = \ _ -> Sub.none
          , view = myview }
