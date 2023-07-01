import Data.List (find, isPrefixOf, foldl') --'
import Data.Bool (bool)

multiSplit :: [String] -> String -> [(String, String, Int)]
multiSplit ds s =
  let (ts, ps, o) =
        foldl' --'
          (\(tokens, parts, offset) (c, i) ->
              let inDelim = offset > i
              in maybe
                   (bool (c : tokens) tokens inDelim, parts, offset)
                   (\x -> ([], (tokens, x, i) : parts, i + length x))
                   (bool (find (`isPrefixOf` drop i s) ds) Nothing inDelim))
          ([], [], 0)
          (zip s [0 ..])
  in reverse $ (ts, [], length s) : ps
main :: IO ()
main = print $ multiSplit ["==", "!=", "="] "a!===b=!=c"
