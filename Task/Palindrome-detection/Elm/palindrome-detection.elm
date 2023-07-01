import String exposing (reverse, length)
import Html exposing (Html, Attribute, text, div, input)
import Html.Attributes exposing (placeholder, value, style)
import Html.Events exposing (on, targetValue)
import Html.App exposing (beginnerProgram)

-- The following function (copied from Haskell) satisfies the
-- rosettacode task description.
is_palindrome x = x == reverse x

-- The remainder of the code demonstrates the use of the function
-- in a complete Elm program.
main = beginnerProgram { model = "" , view = view , update = update }

update newStr oldStr = newStr

view : String -> Html String
view candidate =
  div []
    ([ input
        [ placeholder "Enter a string to check."
        , value candidate
        , on "input" targetValue
        , myStyle
        ]
        []
     ] ++
     [ let testResult =
             is_palindrome candidate

           statement =
             if testResult then "PALINDROME!" else "not a palindrome"

       in div [ myStyle] [text statement]
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
