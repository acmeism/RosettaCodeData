import Data.List (intercalate)

--------------------- COMMA QUIBBLING --------------------

quibble :: [String] -> String
quibble ws@(_ : _ : _) =
  intercalate
    " and "
    ( [intercalate ", " . reverse . tail, head]
        <*> [reverse ws]
    )
quibble xs = concat xs

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ (putStrLn . (`intercalate` ["{", "}"]) . quibble) $
    [[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]]
      <> ( words
             <$> [ "One two three four",
                   "Me myself I",
                   "Jack Jill",
                   "Loner"
                 ]
         )
