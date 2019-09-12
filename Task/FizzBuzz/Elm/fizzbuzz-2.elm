import Html exposing (text)
import List exposing (map)
import String exposing (join, fromInt)

main : Html.Html
main =
  [1..100] |> map fizzbuzz |> join " " |> text

fizzbuzz : Int -> String
fizzbuzz num =
  let
    fizz = if num % 3 == 0 then "Fizz" else ""
    buzz = if num % 5 == 0 then "Buzz" else ""
  in
    if fizz == buzz then
      fromInt num
    else
      fizz ++ buzz
