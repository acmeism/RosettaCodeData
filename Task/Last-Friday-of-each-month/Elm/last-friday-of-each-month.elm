import Html exposing (Html, Attribute, text, div, input)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (placeholder, value, style)
import Html.Events exposing (onInput)
import String exposing (toInt)
import Maybe exposing (withDefault)
import List exposing (map, map2)
import List.Extra exposing (scanl1)

type Msg = SetYear String

lastFridays : Int -> List Int
lastFridays year =
  let isLeap = (year % 400) == 0 || ( (year % 4) == 0 && (year % 100) /= 0 )
      daysInMonth = [31, if isLeap then 29 else 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
      y = year-1
  in scanl1 (+) daysInMonth
     |> map2 (\len day -> len - (day + 2 + y + y//4 - y//100 + y//400) % 7) daysInMonth

lastFridayStrings : String -> List String
lastFridayStrings yearString =
  let months= ["January ", "February ", "March ", "April ", "May ", "June ", "July ", "August ", "September ", "October ", "November ", "December "]
      errString = "Only years after 1752 are valid."
  in case toInt yearString of
       Ok year ->
           if (year < 1753)
           then [errString]
           else lastFridays year
                |> map2 (\m d -> m ++ toString d ++ ", " ++ toString year) months
       Err _ ->
           [errString]

view :  String -> Html Msg
view yearString =
  div []
    ([ input
        [ placeholder "Enter a year."
        , value yearString
        , onInput SetYear
        , myStyle
        ]
        []
     ] ++ (lastFridayStrings yearString
           |> map (\date -> div [ myStyle ] [ text date ]) ))

myStyle : Attribute Msg
myStyle =
  style
    [ ("width", "100%")
    , ("height", "20px")
    , ("padding", "5px 0 0 5px")
    , ("font-size", "1em")
    , ("text-align", "left")
    ]

update : Msg -> String -> String
update msg _ =
    case msg of
        SetYear yearString -> yearString


main =
    beginnerProgram
        { model = ""
        , view = view
        , update = update
        }
