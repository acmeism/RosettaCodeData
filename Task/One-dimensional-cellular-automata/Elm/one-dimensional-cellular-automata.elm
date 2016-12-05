import Maybe exposing (withDefault)
import List exposing (length, tail, reverse, concat, head, append, map3)
import Html exposing (Html, div, h1, text)
import String exposing (join)
import Svg exposing (svg)
import Svg.Attributes exposing (version, width, height, viewBox,cx,cy, fill, r)
import Html.App exposing (program)
import Random exposing (step, initialSeed, bool, list)
import Matrix exposing (fromList, mapWithLocation, flatten)  -- chendrix/elm-matrix
import Time exposing (Time, second, every)

type alias Model = { history : List (List Bool)
                   , cols : Int
                   , rows : Int
                   }

view : Model -> Html Msg
view model =
  let
    circleInBox (row,col) value =
      if value
      then [ Svg.circle [ r "0.3"
                        , fill ("purple")
                        , cx (toString (toFloat col + 0.5))
                        , cy (toString (toFloat row + 0.5))
                        ]
                        []
           ]
      else []

    showHistory model =
      model.history
        |> reverse
        |> fromList
        |> mapWithLocation circleInBox
        |> flatten
        |> concat
  in
    div []
        [ h1 [] [text "One Dimensional Cellular Automata"]
        , svg [ version "1.1"
              , width "700"
              , height "700"
              , viewBox (join " "
                           [ 0 |> toString
                           , 0 |> toString
                           , model.cols |> toString
                           , model.rows |> toString
                           ]
                        )
              ]
              (showHistory model)
        ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  if length model.history == model.rows
  then (model, Cmd.none)
  else
    let s1 = model.history |> head |> withDefault []
        s0 = False :: s1
        s2 = append (tail s1 |> withDefault []) [False]

        gen d0 d1 d2 =
          case (d0,d1,d2) of
            (False,  True,  True) -> True
            ( True, False,  True) -> True
            ( True,  True, False) -> True
            _                     -> False

        updatedHistory = map3 gen s0 s1 s2 :: model.history
        updatedModel = {model | history = updatedHistory}
    in (updatedModel, Cmd.none)


init : Int -> (Model, Cmd Msg)
init n =
  let gen1 = fst (step (list n bool) (initialSeed 34))
  in ({ history = [gen1], rows = n, cols= n }, Cmd.none)

type Msg = Tick Time

subscriptions model = every (0.2 * second) Tick

main = program
         {  init = init 40
         ,  view = view
         ,  update = update
         ,  subscriptions = subscriptions
         }
