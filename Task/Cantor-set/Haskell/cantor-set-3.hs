import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List (intercalate, mapAccumL, maximumBy)
import Data.Ratio (Ratio, denominator, numerator, (%))

-------------------------- CANTOR ------------------------

cantor :: (Rational, Rational) -> [[(Rational, Rational)]]
cantor = iterate (go =<<) . pure
  where
    go (x, y) = [(x, x + r), (y - r, y)]
      where
        r = (y - x) / 3

--------------------------- TEST -------------------------

main :: IO ()
main =
  ( ( (>>)
        . putStrLn
        . unlines
        . fmap intervalRatios
    )
      <*> (putStrLn . intervalBars)
  )
    $ take 4 $ cantor (0, 1)

------------------------- DISPLAY ------------------------

intervalBars :: [[(Rational, Rational)]] -> String
intervalBars xs = unlines $ go (d % 1) <$> xs
  where
    d = maximum $ denominator . fst <$> last xs
    go w xs =
      concat . snd $
        mapAccumL
          ( \a (rx, ry) ->
              let (wy, wx) = (w * ry, w * rx)
               in ( wy,
                    replicate (floor (wx - a)) ' '
                      <> replicate (floor (wy - wx)) '█'
                  )
          )
          0
          xs

intervalRatios :: [(Rational, Rational)] -> String
intervalRatios =
  ('(' :) . (<> ")")
    . intercalate ") ("
    . fmap
      (uncurry ((<>) . (<> ", ")) . join bimap showRatio)

showRatio :: Rational -> String
showRatio = ((<>) . show . numerator) <*> (go . denominator)
  where
    go x
      | 1 /= x = '/' : show x
      | otherwise = []
