import Control.Monad

main = do
  forM_ [1..5] $ \i -> do
    forM_ [1..i] $ \j -> do
      putChar '*'
    putChar '\n'
