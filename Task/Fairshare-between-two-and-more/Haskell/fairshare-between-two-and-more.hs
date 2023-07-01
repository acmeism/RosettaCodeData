import Data.Bool (bool)
import Data.List (intercalate, unfoldr)
import Data.Tuple (swap)

------------- FAIR SHARE BETWEEN TWO AND MORE ------------

thueMorse :: Int -> [Int]
thueMorse base = baseDigitsSumModBase base <$> [0 ..]

baseDigitsSumModBase :: Int -> Int -> Int
baseDigitsSumModBase base n =
  mod
    ( sum $
        unfoldr
          ( bool Nothing
              . Just
              . swap
              . flip quotRem base
              <*> (0 <)
          )
          n
    )
    base

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    fTable
      ( "First 25 fairshare terms "
          <> "for a given number of players:\n"
      )
      show
      ( ('[' :) . (<> "]") . intercalate ","
          . fmap show
      )
      (take 25 . thueMorse)
      [2, 3, 5, 11]

------------------------- DISPLAY ------------------------
fTable ::
  String ->
  (a -> String) ->
  (b -> String) ->
  (a -> b) ->
  [a] ->
  String
fTable s xShow fxShow f xs =
  unlines $
    s :
    fmap
      ( ((<>) . justifyRight w ' ' . xShow)
          <*> ((" -> " <>) . fxShow . f)
      )
      xs
  where
    w = maximum (length . xShow <$> xs)

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
