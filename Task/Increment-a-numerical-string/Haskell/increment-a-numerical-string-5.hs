import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)

succString :: Bool -> String -> String
succString pruned s =
  let succs
        :: (Num a, Show a)
        => a -> Maybe String
      succs = Just . show . (1 +)
      go w
        | elem '.' w = (readMaybe w :: Maybe Double) >>= succs
        | otherwise = (readMaybe w :: Maybe Integer) >>= succs
      opt w
        | pruned = Nothing
        | otherwise = Just w
  in unwords $
     mapMaybe
       (\w ->
           case go w of
             Just s -> Just s
             _ -> opt w)
       (words s)


-- TEST ---------------------------------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
  succString <$> [True, False] <*>
  pure "41.0 pine martens in 1491 -1.5 mushrooms ≠ 136"
