import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (style)


-- Test cases

nr1 : Int
nr1 =
    2 * 3 * 5 * 7 * 11


nr2 : Int
nr2 =
    7 * 11 * 13 * 17 * 23


main : Html msg
main =
    div [ style "margin" "5%", style "font-size" "1.5em", style "color" "blue" ]
        [ h1 [ style "font-size" "1.5em" ] [ text "GCD Calculator" ]
        , text
            ("number a = "
                ++ String.fromInt nr1
                ++ ",  number b = "
                ++ String.fromInt nr2
            )
        , p [] [ text ("GCD = " ++ String.fromInt (gcd nr1 nr2)) ]
        ]


gcd : Int -> Int -> Int
gcd anr bnr =
    if bnr /= 0 then
        gcd bnr (modBy bnr anr)

    else
        abs anr
