import Graphics.Element exposing (show)
import List exposing (map)

main =
  map getWordForNum [1..100] |> show

getWordForNum num =
  if num % 15 == 0 then
    "FizzBuzz"
  else if num % 3 == 0 then
    "Fizz"
  else if num % 5 == 0 then
    "Buzz"
  else
    toString num
