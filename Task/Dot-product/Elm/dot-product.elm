dotp: List number -> List number -> Maybe number
dotp a b =
    if List.length a /= List.length b then
        Nothing
    else
        Just (List.sum <| List.map2 (*) a b)

dotp [1,3,-5] [4,-2,-1])
