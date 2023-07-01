import           Control.Monad (guard)
import           Data.List (find, unfoldr)
import           Data.Char (intToDigit)
import qualified Data.Set as Set
import           Text.Printf (printf)

digits :: Integral a => a -> a -> [a]
digits
  b = unfoldr
        (((>>) . guard . (0 /=)) <*> (pure . ((,) <$> (`mod` b) <*> (`div` b))))

sequenceForBaseN :: Integral a => a -> [a]
sequenceForBaseN
  b = unfoldr (\(v, n) -> Just (v, (v + n, n + 2))) (i ^ 2, i * 2 + 1)
  where
    i = succ (round $ sqrt (realToFrac (b ^ pred b)))

searchSequence :: Integral a => a -> Maybe a
searchSequence
  b = find ((digitsSet ==) . Set.fromList . digits b) (sequenceForBaseN b)
  where
    digitsSet = Set.fromList [0 .. pred b]

display :: Integer -> Integer -> String
display b n = map (intToDigit . fromIntegral) $ reverse $ digits b n

main :: IO ()
main = mapM_
  (\b -> case searchSequence b of
     Just n  -> printf
       "Base %2d: %8s² -> %16s\n"
       b
       (display b (squareRootValue n))
       (display b n)
     Nothing -> pure ())
  [2 .. 16]
  where
    squareRootValue = round . sqrt . realToFrac
