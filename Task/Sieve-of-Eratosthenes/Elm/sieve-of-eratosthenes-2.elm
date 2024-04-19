module Main exposing (main)

import Browser exposing (element)
import Task exposing (Task, succeed, perform, andThen)
import Html exposing (Html, div, text)
import Time exposing (now, posixToMillis)

import Array exposing (repeat, get, set)

cLIMIT : Int
cLIMIT = 1000000

primesArray : Int -> List Int
primesArray n =
  if n < 2 then [] else
  let
    sz = n + 1
    loopbp bp arr =
      let s = bp * bp in
      if s >= sz then arr else
      let tst = get bp arr |> Maybe.withDefault True in
      if tst then loopbp (bp + 1) arr else
      let
        cullc c iarr =
          if c >= sz then iarr else
          cullc (c + bp) (set c True iarr)
      in loopbp (bp + 1) (cullc s arr)
    cmpsts = loopbp 2 (repeat sz False)
    cnvt (i, t) = if t then Nothing else Just i
  in cmpsts |> Array.toIndexedList
      |> List.drop 2 -- skip the values for zero and one
      |> List.filterMap cnvt -- primes are indexes of not composites

type alias Model = List String

type alias Msg = Model

test : (Int -> List Int) -> Int -> Cmd Msg
test primesf lmt =
  let
    to100 = primesf 100 |> List.map String.fromInt |> String.join ", "
    to100str = "The primes to 100 are:  " ++ to100
    timemillis() = now |> andThen (succeed << posixToMillis)
  in timemillis() |> andThen (\ strt ->
       let cnt = primesf lmt |> List.length
       in timemillis() |> andThen (\ stop ->
         let answrstr = "Found " ++ (String.fromInt cnt) ++ " primes to "
                          ++ (String.fromInt cLIMIT) ++ " in "
                          ++ (String.fromInt (stop - strt)) ++ " milliseconds."
         in succeed [to100str, answrstr] ) ) |> perform identity

main : Program () Model Msg
main =
  element { init = \ _ -> ( [], test primesArray cLIMIT )
          , update = \ msg _ -> (msg, Cmd.none)
          , subscriptions = \ _ -> Sub.none
          , view = div [] << List.map (div [] << List.singleton << text) }
