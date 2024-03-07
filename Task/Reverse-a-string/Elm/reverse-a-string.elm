module Main exposing (main)

import Html exposing (Html, text, div, p)
import Html.Attributes exposing (style)


change myText =
   text ("reverse " ++ myText
    ++ " = " ++ String.reverse myText)


main =
   div [style "margin" "5%", style "font-size" "1.5em"]
    [change "as⃝da"
    , p [] [change "a⃝su-as⃝u"]
    , p [] [change "Hello!"]
    ]
