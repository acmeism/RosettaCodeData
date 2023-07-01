import qualified Data.ByteString as BY (writeFile, pack)

import Data.Bits (xor)

main :: IO ()
main =
  BY.writeFile
    "out.pgm"
    (BY.pack
       (fmap (fromIntegral . fromEnum) "P5\n256 256\n256\n" ++
        [ x `xor` y
        | x <- [0 .. 255]
        , y <- [0 .. 255] ]))
