import Html.App exposing (program)
import Time exposing (Time, every, millisecond)
import Color exposing (Color, black, red, blue, green)
import Collage exposing (collage)
import Collage exposing (collage,polygon, filled, move, Form, circle)
import Element exposing (toHtml)
import Html exposing (Attribute, Html, text, div, input, button)
import Html.Attributes as A exposing (type', min, placeholder, value, style, disabled)
import Html.Events exposing (onInput, targetValue, onClick)
import Dict exposing (Dict, get, insert)
import String exposing (toInt)
import Result exposing (withDefault)
import Random.Pcg as Random exposing (Seed, bool, initialSeed, independentSeed, step, map)

width = 500
height = 600
hscale = 10.0
vscale = hscale * 2
margin = 30
levelCount = 12
radius = hscale/ 2.0

type State = InBox Int Int Seed | Falling Int Float Float Float | Landed Int Float

type Coin = Coin State Color

colorCycle : Int -> Color
colorCycle i =
  case i % 3 of
    0 -> red
    1 -> blue
    _ -> green

initCoin : Int -> Seed -> Coin
initCoin indx seed = Coin (InBox 0 0 seed) (colorCycle indx)

drawCoin : Coin -> Form
drawCoin (Coin state color) =
  let dropLevel = toFloat (height//2 - margin)
      (level, shift, distance) =
        case state of
          InBox level shift seed -> (level, shift, 0)
          Falling shift distance _ _-> (levelCount, shift, distance)
          Landed shift distance -> (levelCount, shift, distance)
      position =
        (             hscale * toFloat shift
        , dropLevel - vscale * (toFloat level) - distance + radius / 2.0)

  in radius |> circle |> filled color |> move position

drawGaltonBox : List Form
drawGaltonBox =
  let levels = [0..levelCount-1]

      -- doubles :
      -- [0,2,4,6,8...]
      doubles = List.map (\n -> 2 * n) levels

      -- sequences :
      -- [[0], [0,2], [0,2,4], [0,2,4,6], [0,2,4,6,8],...]
      sequences = case List.tail (List.scanl (::) [] (doubles)) of
        Nothing -> []
        Just ls -> ls

      -- galtonCoords :
      -- [                            (0,0),
      --                       (-1,1),      (1,1),
      --                (-2,2),       (0,2),      (2,2),
      --         (-3,3),       (-1,3),      (1,3),      (3,3),
      --  (-4,4),       (-2,4),       (0,4),      (2,4),      (4,4), ...]
      galtonCoords =
        List.map2
          (\ls level -> List.map (\n -> (n - level, level)) ls)
          sequences
          levels
        |> List.concat

      peg = polygon [(0,0), (-4, -8), (4, -8)] |> filled black

      apex = toFloat (height//2 - margin)

  in List.map (\(x,y) -> move (hscale*toFloat x,  apex - vscale*toFloat y) peg) galtonCoords

coinsInBin : Int -> Dict Int Int -> Int
coinsInBin binNumber bins =
  case get binNumber bins of
    Nothing -> 0
    Just n -> n

addToBins : Int -> Dict Int Int -> Dict Int Int
addToBins binNumber bins =
  insert binNumber (coinsInBin binNumber bins + 1) bins

updateCoin : (Coin, Dict Int Int) -> (Coin, Dict Int Int)
updateCoin (Coin state color as coin, bins) =
  case state of
    InBox level shift seed ->
      let deltaShift = map (\b -> if b then 1 else -1) bool
          (delta, newSeed) = step deltaShift seed
          newShift = shift+delta
          newLevel = (level)+1
      in if (newLevel < levelCount) then
           (Coin (InBox newLevel newShift newSeed) color, bins)
         else -- transition to falling
           let maxDrop = toFloat (height - 2 * margin) - toFloat (levelCount) * vscale
               floor = maxDrop - toFloat (coinsInBin newShift bins) * (radius*2 + 1)
           in (Coin (Falling newShift -((vscale)/2.0) 10 floor) color, addToBins newShift bins)

    Falling shift distance velocity floor ->
      let newDistance = distance + velocity
      in if (newDistance < floor) then
           (Coin (Falling shift newDistance (velocity + 1) floor) color, bins)
         else -- transtion to landed
           (Coin (Landed shift floor) color, bins)

    Landed _ _ -> (coin, bins) -- unchanged

type alias Model =
  { coins : List Coin
  , bins : Dict Int Int
  , count : Int
  , started : Bool
  , seedInitialized : Bool
  , seed : Seed
  }

init : (Model, Cmd Msg)
init =
  ( { coins = []
    , bins = Dict.empty
    , count = 0
    , started = False
    , seedInitialized = False
    , seed = initialSeed 45 -- This will not get used.  Actual seed used is time dependent and set when the first coin drops.
    }, Cmd.none)

type Msg = Drop Time | Tick Time | SetCount String | Go

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Go ->
      ({model | started = model.count > 0}, Cmd.none)

    SetCount countString ->
      ({ model | count = toInt countString |> withDefault 0 }, Cmd.none)

    Drop t ->
      if (model.started && model.count > 0) then
          let newcount = model.count - 1
              seed' =  if model.seedInitialized then model.seed else initialSeed (truncate t)
              (seed'', coinSeed) = step independentSeed seed'
          in ({ model
              | coins = initCoin (truncate t) coinSeed :: model.coins
              , count = newcount
              , started = newcount > 0
              , seedInitialized = True
              , seed = seed''}, Cmd.none)
      else
         (model, Cmd.none)

    Tick _ ->
      -- foldr to execute update, append to coins, replace bins
      let (updatedCoins, updatedBins) =
        List.foldr (\coin (coinList, bins) ->
                       let (updatedCoin, updatedBins) = updateCoin (coin, bins)
                       in (updatedCoin :: coinList, updatedBins))
                   ([], model.bins)
                   model.coins
      in ({ model | coins = updatedCoins, bins = updatedBins}, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ input
        [ placeholder "How many?"
        , let showString = if model.count > 0 then model.count |> toString else ""
          in value showString
        , onInput SetCount
        , disabled model.started
        , style [ ("height", "20px") ]
        , type' "number"
        , A.min "1"
        ]
        []

     , button
        [ onClick Go
        , disabled model.started
        , style [ ("height", "20px") ]
        ]
        [ Html.text "GO!" ]

     , let coinForms = (List.map (drawCoin) model.coins)
       in collage width height (coinForms ++ drawGaltonBox) |> toHtml
    ]

subscriptions model =
    Sub.batch
        [ every (40*millisecond) Tick
        , every (200*millisecond) Drop
        ]

main =
  program
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }
