module Main exposing (..)

import Html exposing (Html, div, p, text, button, span, h2)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Keyboard exposing (KeyCode)
import Random
import Tuple


main =
    Html.program
        { init = ( { initialModel | waitingForRandom = True }, generateRandomTiles 2 )
        , view = view
        , update = update
        , subscriptions = always (Keyboard.downs KeyPress)
        }



-- MODEL


-- tiles either have a value (2, 4, 8, ...) or are empty
type alias Tile =
    Maybe Int


type alias Model =
    { score : Int
    , tiles : List Tile
    , hasLost : Bool
    , winKeepPlaying : Bool
    , waitingForRandom : Bool -- prevent user from giving input while waiting for Random Cmd to return
    }


initialModel : Model
initialModel =
    { score = 0, tiles = List.repeat 16 Nothing, waitingForRandom = False, hasLost = False, winKeepPlaying = False}



-- UPDATE


type alias RandomTileInfo =
    ( Int, Int )


type Msg
    = KeyPress KeyCode
    | AddRandomTiles (List RandomTileInfo)
    | NewGame
    | KeepPlaying



-- asks the random generator to generate the information required for later adding random tiles
-- generate a random position for the and value (4 10%, 2 90%) for each tile
-- this uses Random.pair and Random.list to get a variable number of such pairs with one Cmd
generateRandomTiles : Int -> Cmd Msg
generateRandomTiles num =
    let
        randomPosition =
            Random.int 0 15

        randomValue =
            Random.int 1 10
                |> Random.map
                    (\rnd ->
                        if rnd == 10 then
                            4
                        else
                            2
                    )

        -- 10% chance
        randomPositionAndValue =
            Random.pair randomPosition randomValue
    in
        Random.list num randomPositionAndValue |> Random.generate AddRandomTiles



-- actually add a random tile to the model
addRandomTile : RandomTileInfo -> List Tile -> List Tile
addRandomTile ( newPosition, newValue ) tiles =
    let
        -- newPosition is a value between 0 and 15
        -- go through the list and count the amount of empty tiles we've seen.
        -- if we reached the newPosition % emptyTileCount'th empty tile, set its value to newValue
        emptyTileCount =
            List.filter ((==) Nothing) tiles |> List.length

        -- if there are less than 16 empty tiles this is the number of empty tiles we pass
        targetCount =
            newPosition % emptyTileCount

        set_ith_empty_tile tile ( countEmpty, newList ) =
            case tile of
                Just value ->
                    ( countEmpty, (Just value) :: newList )

                Nothing ->
                    if countEmpty == targetCount then
                        -- replace this empty tile with the new value
                        ( countEmpty + 1, (Just newValue) :: newList )
                    else
                        ( countEmpty + 1, Nothing :: newList )
    in
        List.foldr set_ith_empty_tile ( 0, [] ) tiles |> Tuple.second



-- core game mechanic: move numbers (to the left,
-- moving to the right is equivalent to moving left on the reversed array)
-- this function works on single columns/rows
moveNumbers : List Tile -> ( List Tile, Int )
moveNumbers tiles =
    let
        last =
            List.head << List.reverse

        -- init is to last what tail is to head
        init =
           List.reverse << List.drop 1 << List.reverse

        doMove tile ( newTiles, addScore ) =
            case tile of
                -- omit empty tiles when shifting
                Nothing ->
                    ( newTiles, addScore )

                Just value ->
                    case last newTiles of
                        -- if the last already moved tile ...
                        Just (Just value2) ->
                            -- ... has the same value, add a tile with the summed value
                            if value == value2 then
                                ( (init newTiles) ++ [ Just (2 * value) ]
                                , addScore + 2 * value )
                            else
                                -- ... else just add the tile
                                ( newTiles ++ [ Just value ], addScore )

                        _ ->
                            -- ... else just add the tile
                            ( newTiles ++ [ Just value ], addScore )

        ( movedTiles, addScore ) =
            List.foldl doMove ( [], 0 ) tiles
    in
        ( movedTiles ++ List.repeat (4 - List.length movedTiles) Nothing, addScore )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- new game button press
        NewGame ->
            if not model.waitingForRandom then
                ( { initialModel | waitingForRandom = True }, generateRandomTiles 2 )
            else
                ( model, Cmd.none )

        -- "keep playing" button on win screen
        KeepPlaying ->
            ( { model | winKeepPlaying = True }, Cmd.none)

        -- Random generator Cmd response
        AddRandomTiles tileInfos ->
            let
                newTiles =
                    List.foldl addRandomTile model.tiles tileInfos
            in
                ( { model | tiles = newTiles, waitingForRandom = False }, Cmd.none )


        KeyPress code ->
            let
                -- zip list and indices, apply filter, unzip
                indexedFilter func list =
                    List.map2 (,) (List.range 0 (List.length list - 1)) list
                        |> List.filter func
                        |> List.map Tuple.second

                -- the i'th row (of 4) contains elements i*4, i*4+1, i*4+2, i*4+3
                -- so all elements for which index//4 == i
                i_th_row list i =
                    indexedFilter (((==) i) << (flip (//) 4) << Tuple.first) list

                -- the i'th col (of 4) contain elements i, i+4, i+2*4, i+3*4
                -- so all elements for which index%4 == i
                i_th_col list i =
                    indexedFilter (((==) i) << (flip (%) 4) << Tuple.first) list

                -- rows and columns of the grid
                rows list =
                    List.map (i_th_row list) (List.range 0 3)

                cols list =
                    List.map (i_th_col list) (List.range 0 3)

                -- move each row or column and unzip the results from each call to moveNumbers
                move =
                    List.unzip << List.map moveNumbers

                moveReverse =
                    List.unzip << List.map (Tuple.mapFirst List.reverse << moveNumbers << List.reverse)

                -- concat rows back into a flat array and sum all addScores
                unrows =
                    Tuple.mapSecond List.sum << Tuple.mapFirst List.concat

                -- turn columns back into a flat array and sum all addScores
                uncols =
                    Tuple.mapSecond List.sum << Tuple.mapFirst (List.concat << cols << List.concat)


                -- when shifting left or right each row can be (reverse-) shifted separately
                -- when shifting up or down each column can be (reveerse-) shifted separately
                ( newTiles, addScore ) =
                    case code of
                        37 ->
                            -- left
                            unrows <| move <| rows model.tiles

                        38 ->
                            -- up
                            uncols <| move <| cols model.tiles

                        39 ->
                            -- right
                            unrows <| moveReverse <| rows model.tiles

                        40 ->
                            -- down
                            uncols <| moveReverse <| cols model.tiles

                        _ ->
                            ( model.tiles, 0 )


                containsEmptyTiles =
                    List.any ((==) Nothing)

                containsAnySameNeighbours : List Tile -> Bool
                containsAnySameNeighbours list =
                    let
                        tail = List.drop 1 list
                        init = List.reverse <| List.drop 1 <| List.reverse list
                    in
                        List.any (uncurry (==)) <| List.map2 (,) init tail
                hasLost =
                     -- grid full
                    (not (containsEmptyTiles newTiles))
                        -- and no left/right move possible
                        && (not <| List.any containsAnySameNeighbours <| rows newTiles)
                        -- and no up/down move possible
                        && (not <| List.any containsAnySameNeighbours <| cols newTiles)

                ( cmd, waiting ) =
                    if List.all identity <| List.map2 (==) model.tiles newTiles then
                        ( Cmd.none, False )
                    else
                        ( generateRandomTiles 1, True )

                score =
                    model.score + addScore
            in
                -- unsure whether this actually happens but regardless:
                -- keep the program from accepting a new keyboard input when a new tile hasn't been spawned yet
                if model.waitingForRandom then
                    ( model, Cmd.none )
                else
                    ( { model | tiles = newTiles, waitingForRandom = waiting, score = score, hasLost = hasLost }, cmd )




-- VIEW


containerStyle : List ( String, String )
containerStyle =
    [ ( "width", "450px" )
    , ( "height", "450px" )
    , ( "background-color", "#bbada0" )
    , ( "float", "left" )
    , ( "border-radius", "6px")
    ]


tileStyle : Int -> List ( String, String )
tileStyle value =
    let
        color =
            case value of
                0 ->
                    "#776e65"

                2 ->
                    "#eee4da"

                4 ->
                    "#ede0c8"

                8 ->
                    "#f2b179"

                16 ->
                    "#f59563"

                32 ->
                    "#f67c5f"

                64 ->
                    "#f65e3b"

                128 ->
                    "#edcf72"

                256 ->
                    "#edcc61"

                512 ->
                    "#edc850"

                1024 ->
                    "#edc53f"

                2048 ->
                    "#edc22e"

                _ ->
                    "#edc22e"
    in
        [ ( "width", "100px" )
        , ( "height", "70px" )
        , ( "background-color", color )
        , ( "float", "left" )
        , ( "margin-left", "10px" )
        , ( "margin-top", "10px" )
        , ( "padding-top", "30px" )
        , ( "text-align", "center" )
        , ( "font-size", "30px" )
        , ( "font-weight", "bold" )
        , ( "border-radius", "6px")
        ]


viewTile : Tile -> Html Msg
viewTile tile =
    div [ style <| tileStyle <| Maybe.withDefault 0 tile ]
        [ span [] [ text <| Maybe.withDefault "" <| Maybe.map toString tile ]
        ]


viewGrid : List Tile -> Html Msg
viewGrid tiles =
    div [ style containerStyle ] <| List.map viewTile tiles


viewLost : Html Msg
viewLost =
    div
        [ style containerStyle ]
        [ div
            [ style [ ( "text-align", "center" ) ] ]
            [ h2 [] [ text "You lost!" ]
            ]
        ]

viewWin : Html Msg
viewWin =
    div
        [ style containerStyle ]
        [ div
            [ style [ ( "text-align", "center" ) ] ]
            [ h2 [] [ text "Congratulations, You won!" ]
            , button
                [ style [ ( "margin-bottom", "16px" ), ( "margin-top", "16px" ) ], onClick KeepPlaying ]
                [ text "Keep playing" ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ style [ ( "width", "450px" ) ] ]
        [ p [ style [ ( "float", "left" ) ] ] [ text <| "Your Score: " ++ toString model.score ]
        , button
            [ style [ ( "margin-bottom", "16px" ), ( "margin-top", "16px" ), ( "float", "right" ) ], onClick NewGame ]
            [ text "New Game" ]
        , if model.hasLost then
            viewLost
          else if List.any ((==) (Just 2048)) model.tiles && not model.winKeepPlaying then
            viewWin
          else
            viewGrid model.tiles
        ]
