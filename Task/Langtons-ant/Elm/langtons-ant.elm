import Maybe as M
import Matrix
import Time exposing (Time, every, second)
import List exposing (..)
import String exposing (join)
import Html exposing (div, h1, text)
import Html.App exposing (program)
import Svg
import Svg.Attributes exposing (version, viewBox, cx, cy, r, x, y, x1, y1, x2, y2, fill,style, width, height, preserveAspectRatio)

w = 700
h = 700
dt = 0.0001

type Direction = North | West | South | East

type alias Model =
  { rows : Int
  , cols : Int
  , boxes : Matrix.Matrix Bool
  , location : Matrix.Location
  , direction : Direction
  }

initModel : Int -> Int -> Model
initModel cols rows =
     { rows = rows
     , cols = cols
     , boxes = Matrix.matrix rows cols (\location -> False)
     , location = (rows//2,cols//2)
     , direction = North
     }

view model =
  let
    borderLineStyle = style "stroke:black;stroke-width:0.3"

    x1Min = x1 <| toString 0
    y1Min = y1 <| toString 0
    x1Max = x1 <| toString model.cols
    y1Max = y1 <| toString model.rows
    x2Min = x2 <| toString 0
    y2Min = y2 <| toString 0
    x2Max = x2 <| toString model.cols
    y2Max = y2 <| toString model.rows

    borders = [ Svg.line [ x1Min, y1Min, x2Max, y2Min, borderLineStyle ] []
              , Svg.line [ x1Max, y1Min, x2Max, y2Max, borderLineStyle ] []
              , Svg.line [ x1Max, y1Max, x2Min, y2Max, borderLineStyle ] []
              , Svg.line [ x1Min, y1Max, x2Min, y2Min, borderLineStyle ] []
              ]

    circleInBox (row,col) color =
      Svg.circle [ r "0.25"
      , fill (color)
      , cx (toString (toFloat col + 0.5))
      , cy (toString (toFloat row + 0.5))
      ] []

    showUnvisited location box =
       if box then [circleInBox location "black" ]
              else []

    unvisited = model.boxes
                  |> Matrix.mapWithLocation showUnvisited
                  |> Matrix.flatten
                  |> concat

    maze = [ Svg.g [] <| borders ++ unvisited ]

  in
      div
          []
          [ h1 [] [text "Langton's Ant"]
          , Svg.svg
              [ version "1.1"
              , width (toString w)
              , height (toString h)
              , viewBox (join " "
                           [ 0          |> toString
                           , 0          |> toString
                           , model.cols |> toString
                           , model.rows |> toString ])
              ]
              maze
          ]

updateModel : Model -> Model
updateModel model =
      let current = model.location
          inBox =    snd current >= 0 && snd current < model.cols
                  && fst current >= 0 && fst current < model.rows
      in if not inBox then
           model
         else
           let currentValue = Matrix.get current model.boxes |> M.withDefault False

               dir = case (model.direction, currentValue) of
                       (North, True) -> East
                       (East, True) -> South
                       (South, True) -> West
                       (West, True) -> North

                       (North, False) -> West
                       (East, False) -> North
                       (South, False) -> East
                       (West, False) -> South

               next = case dir of
                        North -> (fst current+1, snd current)
                        South -> (fst current-1, snd current)
                        East -> (fst current, snd current+1)
                        West -> (fst current, snd current-1)

               boxes = Matrix.set current (not currentValue) model.boxes

           in {model | boxes=boxes, location=next, direction=dir}

type Msg = Tick Time

subscriptions model = every (dt * second) Tick

main =
  let
    update msg model = (updateModel model, Cmd.none)
    init = (initModel 100 100 , Cmd.none)
  in program
       { init = init
       , view = view
       , update = update
       , subscriptions = subscriptions
       }
