import Control.Monad (join)
import Data.Bool (bool)
import Data.List (unfoldr)
import Data.Tuple (swap)

isMunchausen :: Integer -> Bool
isMunchausen =
  (==)
    <*> ( foldr ((+) . join (^)) 0
            . unfoldr
              ( ( flip bool Nothing
                    . Just
                    . swap
                    . flip quotRem 10
                )
                  <*> (0 ==)
              )
        )

main :: IO ()
main = print $ filter isMunchausen [1 .. 5000]
