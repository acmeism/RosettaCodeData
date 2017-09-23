-- Unoptimized
import List exposing (indexedMap, foldl, repeat, range)
import Html exposing (text)

type Door = Open | Closed

toggle d = if d == Open then Closed else Open

toggleEvery : Int -> List Door -> List Door
toggleEvery k doors = indexedMap
  (\i door -> if i % k == 0 then toggle door else door)
  doors

n = 100

main =
  text (toString (foldl toggleEvery (repeat n Closed) (range 1 n)))
