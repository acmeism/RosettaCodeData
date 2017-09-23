import Data.List (sortBy)
import Data.Ord (comparing)
import Text.Printf (printf)
import Control.Monad (forM_)
import Data.Ratio (numerator, denominator)

maxWgt :: Rational
maxWgt = 15

data Bounty = Bounty
  { itemName :: String
  , itemVal, itemWgt :: Rational
  }

items :: [Bounty]
items =
  [ Bounty "beef" 36 3.8
  , Bounty "pork" 43 5.4
  , Bounty "ham" 90 3.6
  , Bounty "greaves" 45 2.4
  , Bounty "flitch" 30 4.0
  , Bounty "brawn" 56 2.5
  , Bounty "welt" 67 3.7
  , Bounty "salami" 95 3.0
  , Bounty "sausage" 98 5.9
  ]

solution :: [(Rational, Bounty)]
solution = g maxWgt $ sortBy (flip $ comparing f) items
  where
    g room (b@(Bounty _ _ w):bs) =
      if w < room
        then (w, b) : g (room - w) bs
        else [(room, b)]
    f (Bounty _ v w) = v / w

main :: IO ()
main = do
  forM_ solution $ \(w, b) -> printf "%s kg of %s\n" (mixedNum w) (itemName b)
  (printf "Total value: %s\n" . mixedNum . sum) $ f <$> solution
  where
    f (w, Bounty _ v wtot) = v * (w / wtot)
    mixedNum q =
      if b == 0
        then show a
        else printf "%d %d/%d" a (numerator b) (denominator b)
      where
        a = floor q
        b = q - toEnum a
