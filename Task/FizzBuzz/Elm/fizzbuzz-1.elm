import Html exposing (text)
import List exposing (map)

main =
  [1..100] |> map getWordForNum |> text

getWordForNum num =
  if num % 15 == 0 then
    "FizzBuzz"
  else if num % 3 == 0 then
    "Fizz"
  else if num % 5 == 0 then
    "Buzz"
  else
    String.fromInt num
