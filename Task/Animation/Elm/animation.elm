module Main exposing (..)

import Browser
import Html exposing (Html, div, pre, text)
import Html.Events exposing (onClick)
import Time


message : String
message =
    "Hello World! "


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Direction
    = Forwards
    | Backwards


type alias Model =
    { time : Int
    , direction : Direction
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { time = 0, direction = Forwards }, Cmd.none )



-- UPDATE


type Msg
    = Tick
    | SwitchDirection


switchDirection : Direction -> Direction
switchDirection d =
    case d of
        Forwards ->
            Backwards

        Backwards ->
            Forwards


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        nextTime =
            case model.direction of
                Forwards ->
                    model.time - 1

                Backwards ->
                    model.time + 1
    in
    case msg of
        Tick ->
            ( { model | time = modBy (String.length message) nextTime }, Cmd.none )

        SwitchDirection ->
            ( { model | direction = switchDirection model.direction }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 200 (\_ -> Tick)



-- VIEW


rotate : String -> Int -> String
rotate m x =
    let
        end =
            String.slice x (String.length m) m

        beginning =
            String.slice 0 x m
    in
    end ++ beginning


view : Model -> Html Msg
view model =
    div []
        [ pre [ onClick SwitchDirection ]
            [ text <| rotate message model.time ]
        ]
