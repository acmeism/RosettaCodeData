import Prelude hiding (even, odd)

even, odd
  :: (Integral a)
  => a -> Bool
even = (0 ==) . (`rem` 2)

odd = not . even

main :: IO ()
main = print (even <$> [0 .. 9])
