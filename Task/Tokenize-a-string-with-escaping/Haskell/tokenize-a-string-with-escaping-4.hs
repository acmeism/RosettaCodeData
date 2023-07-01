import Data.Bool (bool)

------------------ TOKENIZE WITH ESCAPING ----------------

tokenize :: Char -> Char -> String -> [String]
tokenize delim esc str =
  reverse $
    reverse <$> (token : list)
  where
    (token, list, _) =
      foldr
        ( \x (aToken, aList, aEsc) ->
            let literal = not aEsc
                isEsc = literal && (x == esc)
             in bool
                  ( bool (x : aToken) aToken isEsc,
                    aList,
                    isEsc
                  )
                  ([], aToken : aList, isEsc)
                  (literal && x == delim)
        )
        ([], [], False)
        (reverse str)

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ print $
    tokenize
      '|'
      '^'
      "one^|uno||three^^^^|four^^^|^cuatro|"
