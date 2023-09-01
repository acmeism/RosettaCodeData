import Html exposing (div, p, text)


type alias Block = (Char, Char)


writtenWithBlock : Char -> Block -> Bool
writtenWithBlock letter (firstLetter, secondLetter) =
  letter == firstLetter || letter == secondLetter


canMakeWord : List Block -> String -> Bool
canMakeWord blocks word =
  let
    checkWord w examinedBlocks blocksToExamine =
      case (String.uncons w, blocksToExamine) of
        (Nothing, _) -> True
        (Just _, []) -> False
        (Just (firstLetter, restOfWord), firstBlock::restOfBlocks) ->
           if writtenWithBlock firstLetter firstBlock
           then checkWord restOfWord [] (examinedBlocks ++ restOfBlocks)
           else checkWord w (firstBlock::examinedBlocks) restOfBlocks
  in
  checkWord (String.toUpper word) [] blocks


exampleBlocks =
  [ ('B', 'O')
  , ('X', 'K')
  , ('D', 'Q')
  , ('C', 'P')
  , ('N', 'A')
  , ('G', 'T')
  , ('R', 'E')
  , ('T', 'G')
  , ('Q', 'D')
  , ('F', 'S')
  , ('J', 'W')
  , ('H', 'U')
  , ('V', 'I')
  , ('A', 'N')
  , ('O', 'B')
  , ('E', 'R')
  , ('F', 'S')
  , ('L', 'Y')
  , ('P', 'C')
  , ('Z', 'M')
  ]


exampleWords =
  ["", "A", "bark", "BoOK", "TrEAT", "COmMoN", "Squad", "conFUsE"]


main =
  let resultStr (word, canBeWritten) = "\"" ++ word ++ "\"" ++ ": " ++ if canBeWritten then "True" else "False" in
  List.map (\ word -> (word, canMakeWord exampleBlocks word) |> resultStr) exampleWords
  |> List.map (\result -> p [] [ text result ])
  |> div []
