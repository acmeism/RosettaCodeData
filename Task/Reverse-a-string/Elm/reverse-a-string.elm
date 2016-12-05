-- The import on the next line provides the reverse string
-- functionality satisfying the rosettacode.org task description.
import String exposing (reverse)

-- The rest is fairly boilerplate code demonstrating
-- interactively that the reverse function works.
import Html exposing (Html, Attribute, text, div, input)
import Html.Attributes exposing (placeholder, value, style)
import Html.Events exposing (on, targetValue)
import Html.App exposing (beginnerProgram)

main = beginnerProgram { model = "", view = view, update = update }

update newStr oldStr = newStr

view : String -> Html String
view forward =
  div []
    ([ input
        [ placeholder "Enter a string to be reversed."
        , value forward
        , on "input" targetValue
        , myStyle
        ]
        []
     ] ++
     [ let backward = reverse forward
       in div [ myStyle] [text backward]
     ])

myStyle : Attribute msg
myStyle =
  style
    [ ("width", "100%")
    , ("height", "20px")
    , ("padding", "5px 0 0 5px")
    , ("font-size", "1em")
    , ("text-align", "left")
    ]
