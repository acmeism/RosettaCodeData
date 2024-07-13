module Main exposing (main)

import Browser
import Html exposing (Html, h2, div, p, input, button, text, textarea)
import Html.Attributes exposing (style, class, placeholder, value)
import Html.Events exposing (onInput, onClick)


-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model =
    { codeKey : Int
    , normtext : String
    }


init : Model
init =
    { codeKey = 3
    , normtext = "" }


-- UPDATE

type Msg
    = Change String
    | DecKey
    | IncKey


update : Msg -> Model -> Model
update msg model =
    case msg of
        DecKey ->
            { model | codeKey = model.codeKey - 1}
        IncKey ->
            { model | codeKey = model.codeKey + 1}
        Change newContent ->
            { model | normtext = String.toUpper newContent }



encodeChar : Int -> Char -> Char
encodeChar codeKey character =
    if Char.isUpper character then
        Char.fromCode (modBy 26 (Char.toCode character - 65 + codeKey) + 65)

    else if Char.isLower character then
        Char.fromCode (modBy 26 (Char.toCode (Char.toUpper character) - 65 + codeKey) + 65)

    else
        character


encodeText : Int -> String -> String
encodeText codeKey normtext =
    String.map (encodeChar codeKey) normtext


subheads aKey =
   if aKey > 0 then "Original"
   else if aKey < 0 then "Encrypted text"
   else "?"

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ div []
    [h2 [class "h2style"] [text (subheads model.codeKey)]
    , textarea [ class "textframe", placeholder "Write here your text!"
               , value model.normtext, onInput Change ] []
    ]
    , div []
    [h2 [class "h2style"] [text (subheads (negate model.codeKey))]
    , textarea [ class "textframe", value (encodeText model.codeKey model.normtext) ] []]
    , div [class "keystyle"] [ button [ class "butstyle", onClick DecKey ] [ text "-1" ]
    , text (" Key " ++ String.fromInt model.codeKey)
    , button [ class "butstyle", onClick IncKey ] [ text "+1" ]
    ]
    ]
