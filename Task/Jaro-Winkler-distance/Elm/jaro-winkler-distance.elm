module JaroWinkler exposing (similarity)


commonPrefixLength : List a -> List a -> Int -> Int
commonPrefixLength xs ys counter =
    case ( xs, ys ) of
        ( x :: xs_, y :: ys_ ) ->
            if x == y then
                commonPrefixLength xs_ ys_ (counter + 1)

            else
                counter

        _ ->
            counter

similarity : String -> String -> Float
similarity s1 s2 =
    let
        chars1 =
            String.toList s1

        chars2 =
            String.toList s2

        jaroScore =
            jaro chars1 chars2

        l =
            toFloat <| min (commonPrefixLength chars1 chars2 0) 4

        p =
            0.1
    in
    jaroScore + (l * p * (1.0 - jaroScore))


containtsInNextN : Int -> a -> List a -> Bool
containtsInNextN i a items =
    case ( i, items ) of
        ( 0, _ ) ->
            False

        ( _, [] ) ->
            False

        ( _, item :: rest ) ->
            if item == a then
                True

            else
                containtsInNextN (i - 1) a rest


exists : Int -> Int -> List a -> a -> Bool
exists startAt endAt items i =
    if endAt < startAt then
        False

    else if startAt == 0 then
        case items of
            first :: rest ->
                if i == first then
                    True

                else
                    exists 0 (endAt - 1) rest i

            [] ->
                False

    else
        exists 0 (endAt - startAt) (List.drop startAt items) i


existsInWindow : a -> List a -> Int -> Int -> Bool
existsInWindow item items offset radius =
    let
        startAt =
            max 0 (offset - radius)

        endAt =
            min (offset + radius) (List.length items - 1)
    in
    exists startAt endAt items item


transpositions : List a -> List a -> Int -> Int
transpositions xs ys counter =
    case ( xs, ys ) of
        ( [], _ ) ->
            counter

        ( _, [] ) ->
            counter

        ( x :: xs_, y :: ys_ ) ->
            if x /= y then
                transpositions xs_ ys_ (counter + 1)

            else
                transpositions xs_ ys_ counter


commonItems : List a -> List a -> Int -> List a
commonItems items1 items2 radius =
    items1
        |> List.indexedMap
            (\index item ->
                if existsInWindow item items2 index radius then
                    [ item ]

                else
                    []
            )
        |> List.concat


jaro : List Char -> List Char -> Float
jaro chars1 chars2 =
    let
        minLenth =
            min (List.length chars1) (List.length chars2)

        matchRadius =
            minLenth // 2 + (minLenth |> modBy 2)

        c1 =
            commonItems chars1 chars2 matchRadius

        c2 =
            commonItems chars2 chars1 matchRadius

        c1length =
            toFloat (List.length c1)

        c2length =
            toFloat (List.length c2)

        mismatches =
            transpositions c1 c2 0

        transpositionScore =
            (toFloat mismatches + abs (c1length - c2length)) / 2.0

        s1length =
            toFloat (List.length chars1)

        s2length =
            toFloat (List.length chars2)

        tLength =
            max c1length c2length

        result =
            (c1length / s1length + c2length / s2length + (tLength - transpositionScore) / tLength) / 3.0
    in
    if isNaN result then
        0.0

    else
        result
