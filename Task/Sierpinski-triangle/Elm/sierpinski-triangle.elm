import String exposing (..)
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Html.App exposing (beginnerProgram)
import Result exposing (..)

sierpinski : Int -> List String
sierpinski n =
  let down n = sierpinski (n - 1)
      space n = repeat (2 ^ (n - 1)) " "
  in case n of
       0 -> ["*"]
       _ ->    List.map ((\st -> space n ++ st) << (\st -> st ++ space n)) (down n)
            ++ List.map (join " " << List.repeat 2) (down n)

main = beginnerProgram { model = "4", view = view, update = update }

update newStr oldStr = newStr

view : String -> Html String
view levelString =
  div []
    ([ Html.form
          []
          [ label [ myStyle ] [ text "Level: "]
          , input
            [ placeholder "triangle level."
            , value levelString
            , on "input" targetValue
            , type' "number"
            , A.min "0"
            , myStyle
            ]
            []
          ]
     ] ++
     [ pre [] (levelString
               |> toInt
               |> withDefault 0
               |> sierpinski
               |> List.map (\s -> div [] [text s]))
     ])

myStyle : Attribute msg
myStyle =
  style
    [ ("height", "20px")
    , ("padding", "5px 0 0 5px")
    , ("font-size", "1em")
    , ("text-align", "left")
    ]
