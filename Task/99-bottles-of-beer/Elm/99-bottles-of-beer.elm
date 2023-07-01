module Main exposing (main)

import Html


main =
    List.range 1 100
        |> List.reverse
        |> List.map
            (\n ->
                let
                    nString =
                        String.fromInt n

                    n1String =
                        String.fromInt (n - 1)
                in
                [ nString ++ " bottles of beer on the wall"
                , nString ++ " bottles of beer"
                , "Take one down, pass it around"
                , n1String ++ " bottles of beer on the wall"
                ]
                    |> List.map Html.text
                    |> List.intersperse (Html.br [] [])
                    |> Html.p []
            )
        |> Html.div []
