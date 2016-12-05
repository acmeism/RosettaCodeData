import List exposing (concatMap, foldl, head,member,filter,length,minimum,concat,map,map2,tail)
import List.Extra exposing (minimumBy, andThen)
import String exposing (join)
import Html as H
import Html.Attributes as HA
import Html.App exposing (program)
import Time exposing (Time,every, second)
import Svg exposing (rect, line, svg, g)
import Svg.Events exposing (onClick)
import Svg.Attributes exposing (version, viewBox, x, y, x1, y1, x2, y2, fill, style, width, height)

w = 450
h = 450
rowCount=20
colCount=20
dt = 0.03

type alias Cell = (Int, Int)

type alias Model =
    { path : List Cell
    , board : List Cell
    }

type Msg = NoOp | Tick Time | SetStart Cell

init : (Model,Cmd Msg)
init =
    let board = [0..rowCount-1] `andThen` \r ->
                [0..colCount-1] `andThen` \c ->
                [(r, c)]
        path = []
    in (Model path board, Cmd.none)

view : Model -> H.Html Msg
view model =
    let
        showChecker row col =
            rect [ x <| toString col
                 , y <| toString row
                 , width "1"
                 , height "1"
                 , fill <| if (row + col) % 2 == 0 then "blue" else "grey"
                 , onClick <| SetStart (row, col)
                 ]
                 []

        showMove (row0,col0) (row1,col1) =
            line [ x1 <| toString ((toFloat col0) + 0.5)
                 , y1 <| toString ((toFloat row0) + 0.5)
                 , x2 <| toString ((toFloat col1) + 0.5)
                 , y2 <| toString ((toFloat row1) + 0.5)
                 , style "stroke:yellow;stroke-width:0.05"
                 ]
                 []

        render model =
            let checkers = model.board `andThen` \(r,c) ->
                           [showChecker r c]
                moves = case List.tail model.path of
                        Nothing -> []
                        Just tl -> List.map2 showMove model.path tl
            in checkers ++ moves

        unvisited = length model.board - length model.path

        center = HA.style [ ( "text-align", "center") ]

    in
        H.div
          []
          [ H.h2 [center] [H.text "Knight's Tour"]
          , H.h2 [center] [H.text <| "Unvisited count : " ++ toString unvisited ]
          , H.h2 [center] [H.text "(pick a square)"]
          , H.div
              [center]
              [ svg
                  [ version "1.1"
                  , width (toString w)
                  , height (toString h)
                  , viewBox (join " "
                               [ toString 0
                               , toString 0
                               , toString colCount
                               , toString rowCount ])
                  ]
                  [ g [] <| render model]
              ]
          ]

nextMoves : Model -> Cell -> List Cell
nextMoves model (stRow,stCol) =
  let c = [ 1,  2, -1, -2]

      km = c `andThen` \cRow ->
           c `andThen` \cCol ->
           if abs(cRow) == abs(cCol) then [] else [(cRow,cCol)]

      jumps = List.map (\(kmRow,kmCol) -> (kmRow + stRow, kmCol + stCol)) km

  in List.filter (\j -> List.member j model.board && not (List.member j model.path) ) jumps

bestMove : Model -> Maybe Cell
bestMove model =
    case List.head (model.path) of
        Nothing -> Nothing
        Just mph -> minimumBy (List.length << nextMoves model) (nextMoves model mph)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let mo = case msg of
                 SetStart start ->
                     {model |  path = [start]}
                 Tick t ->
                     case model.path of
                         [] -> model
                         _ -> case bestMove model of
                                  Nothing -> model
                                  Just best -> {model | path = best::model.path }
                 NoOp -> model
    in (mo, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every (dt * second) Tick

main =
  program
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }
