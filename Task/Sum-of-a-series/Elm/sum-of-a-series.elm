module Main exposing (main)

import Html exposing (h1, div, p, text)
import Html.Attributes exposing (style)

aList : List Int
aList = List.range 1 1000


-- version a with a list
k2xSum : Float
k2xSum = List.sum
  <| List.map (\x -> 1.0 / x / x )
    <| List.map (\n -> toFloat n) aList


-- version b with a list
fx : Int -> Float
fx =
    (\n -> toFloat n |> \m -> 1.0 / m / m)

f2kSum : Float
f2kSum = List.sum
  <| List.map fx aList

-- version with recursion, without a list
untilMax : Int -> Int -> Float -> Float
untilMax k kmax accum =
  if k > kmax
    then accum
  else
    let
        x = toFloat k
        dx = 1.0 / x / x
    in  untilMax (k + 1)  kmax (accum + dx)

recSum : Float
recSum = untilMax 1 1000 0.0

main = div [style "margin" "5%", style "color" "blue"] [
   h1 [] [text "Sum of series Σ 1/k²"]
   , text (" Version a with a list: Sum = " ++ String.fromFloat k2xSum)
   , p [] [text (" Version b with a list: Sum = " ++ String.fromFloat f2kSum)]
   , p [] [text (" Recursion version c: Sum = " ++ String.fromFloat recSum)]
]
