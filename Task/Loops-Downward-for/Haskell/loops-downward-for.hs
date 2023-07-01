import Control.Monad

main :: IO ()
main = forM_ [10,9 .. 0] print
