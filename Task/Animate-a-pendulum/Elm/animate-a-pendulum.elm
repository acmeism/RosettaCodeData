import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (..)
import Time exposing (..)
import Html.App exposing (program)

dt = 0.01
scale = 100

type alias Model =
  { angle : Float
  , angVel : Float
  , length : Float
  , gravity : Float
  }

type Msg
    = Tick Time

init : (Model,Cmd Msg)
init =
  ( { angle = 3 * pi / 4
    , angVel = 0.0
    , length = 2
    , gravity = -9.81
    }
  , Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update _ model =
  let
    angAcc = -1.0 * (model.gravity / model.length) * sin (model.angle)
    angVel' = model.angVel + angAcc * dt
    angle' = model.angle + angVel' * dt
  in
    ( { model
        | angle = angle'
        , angVel = angVel'
      }
    , Cmd.none )

view : Model -> Html Msg
view model =
  let
    endPoint = ( 0, scale * model.length )
    pendulum =
      group
        [ segment ( 0, 0 ) endPoint
            |> traced { defaultLine | width = 2, color = red }
        , circle 8
            |> filled blue
        , ngon 3 10
            |> filled green
            |> rotate (pi/2)
            |> move endPoint
        ]
  in
    toHtml <|
      collage 700 500
        [ pendulum |> rotate model.angle ]

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
