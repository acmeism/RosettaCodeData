import Text.Printf

main :: IO ()
main = mapM_ f [0..33] where
  f :: Int -> IO ()
  f n = printf " %3o %2d %2X\n" n n n -- binary not supported
