import Data.List
  ( genericLength,
    intercalate,
    isPrefixOf,
    stripPrefix,
  )

------------------------ MULTISPLIT ----------------------

multisplit :: [String] -> String -> [(String, String, Int)]
multisplit delims = go [] 0
  where
    go acc pos [] = [(acc, [], pos)]
    go acc pos l@(s : sx) =
      case trysplit delims l of
        Nothing -> go (s : acc) (pos + 1) sx
        Just (d, sxx) ->
          (acc, d, pos) :
          go [] (pos + genericLength d) sxx

trysplit :: [String] -> String -> Maybe (String, String)
trysplit delims s =
  case filter (`isPrefixOf` s) delims of
    [] -> Nothing
    (d : _) -> Just (d, (\(Just x) -> x) $ stripPrefix d s)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let parsed = multisplit ["==", "!=", "="] "a!===b=!=c"
  mapM_
    putStrLn
    [ "split string:",
      intercalate "," $ map (\(a, _, _) -> a) parsed,
      "with [(string, delimiter, offset)]:",
      show parsed
    ]
