import Data.List (find, isPrefixOf)

multiSplit :: [String] -> String -> [(String, String, Int)]
multiSplit ds s =
  let lng = length s
      (ts, ps, o) =
        foldl
          (\(tokens, parts, offset) (c, i) ->
              let inDelim = offset > i
              in case (if inDelim
                         then Nothing
                         else find (`isPrefixOf` drop i s) ds) of
                   Just x -> ([], (tokens, x, i) : parts, i + length x)
                   Nothing ->
                     ( if inDelim
                         then tokens
                         else c : tokens
                     , parts
                     , offset))
          ([], [], 0)
          (zip s [0 .. lng])
  in reverse $ (ts, [], lng) : ps

main :: IO ()
main = print $ multiSplit ["==", "!=", "="] "a!===b=!=c"
