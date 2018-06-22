import Control.Monad (when)

main = loop 1024
  where loop n = when (n > 0)
                      (do print n
                          loop (n `div` 2))
