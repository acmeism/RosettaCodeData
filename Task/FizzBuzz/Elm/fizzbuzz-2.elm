import Html exposing (text)
import List exposing (map)
import String exposing (join)

main : Html.Html
main =
  map fizzbuzz [1..100] |> join " " |> text

fizzbuzz : Int -> String
fizzbuzz num =
  let
    fizz = if num % 3 == 0 then "Fizz" else ""
    buzz = if num % 5 == 0 then "Buzz" else ""
  in
    if fizz == buzz then
      toString num
    else
      fizz ++ buzz
