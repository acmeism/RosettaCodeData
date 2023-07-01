import Graphics.Element exposing (Element, show)
import Mouse


main : Signal Element
main =
  Signal.map show Mouse.position
