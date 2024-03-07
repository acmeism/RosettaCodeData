module Main exposing (main)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)

-- See live:
-- <nowiki>https://ellie-app.com/pMYxVPQ4fvca1</nowiki>

accumulator : List Int
accumulator =
    []

compositeNr = 84894624407

ts =
    showFactors compositeNr 2 accumulator


main =
        div
            [ style "margin" "5%"
            , style "font-size" "1.5em"
            , style "color" "blue"
            ]
            [ h1 [] [ text "Prime Factorizer" ]
            , text
                ("Prime factors: "
                    ++ listAsString ts
                    ++ " from number "
                    ++ String.fromInt (List.product ts)
                )
            ]


showFactors : Int -> Int -> List Int -> List Int
showFactors number factor acc =
    if number < 2 then
        acc
        -- returns the final result if number < 2
    else if
        modBy factor number == 0
        -- modulo used to get prime factors
    then let
            v2 : List Int
            v2 =
                factor :: acc
            number2 : Int
            number2 =
                number // factor
        in
        showFactors number2 factor v2
        -- recursive call
        -- this modulus function is used
        -- in order to output factor !=2
    else
        let
            factor2 : Int
            factor2 =
                factor + 1
        in
        showFactors number factor2 acc

listAsString : List Int -> String
listAsString myList =
    List.map String.fromInt myList
        |> List.map (\el -> " " ++ el)
        |> List.foldl (++) " "
