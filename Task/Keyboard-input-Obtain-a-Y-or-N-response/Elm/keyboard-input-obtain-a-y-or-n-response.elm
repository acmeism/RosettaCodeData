import Char
import Graphics.Element exposing (Element, empty, show)
import Keyboard


view : Int -> Element
view keyCode =
  let
    char =
      Char.fromCode keyCode

    showChar =
      toString >> ((++) "The last (y/n) key pressed was: ") >> show
  in
    case char of
      'n' ->
        showChar char

      'y' ->
        showChar char

      _ ->
        empty


main : Signal Element
main =
  Signal.map view Keyboard.presses
