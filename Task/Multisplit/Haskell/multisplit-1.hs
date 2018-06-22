import Data.List
       (isPrefixOf, stripPrefix, genericLength, intercalate)

trysplit :: String -> [String] -> Maybe (String, String)
trysplit s delims =
  case filter (`isPrefixOf` s) delims of
    [] -> Nothing
    (d:_) -> Just (d, (\(Just x) -> x) $ stripPrefix d s)

multisplit :: String -> [String] -> [(String, String, Int)]
multisplit list delims =
  let ms [] acc pos = [(acc, [], pos)]
      ms l@(s:sx) acc pos =
        case trysplit l delims of
          Nothing -> ms sx (s : acc) (pos + 1)
          Just (d, sxx) -> (acc, d, pos) : ms sxx [] (pos + genericLength d)
  in ms list [] 0

main :: IO ()
main = do
  let parsed = multisplit "a!===b=!=c" ["==", "!=", "="]
  mapM_
    putStrLn
    [ "split string:"
    , intercalate "," $ map (\(a, _, _) -> a) parsed
    , "with [(string, delimiter, offset)]:"
    , show parsed
    ]
