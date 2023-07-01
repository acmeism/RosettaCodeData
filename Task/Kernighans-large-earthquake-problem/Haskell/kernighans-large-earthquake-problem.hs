import qualified Data.ByteString.Lazy.Char8 as C

main :: IO ()
main = do
  cs <- C.readFile "data.txt"
  mapM_ print $
    C.lines cs >>=
    (\x ->
        [ x
        | 6 < (read (last (C.unpack <$> C.words x)) :: Float) ])
