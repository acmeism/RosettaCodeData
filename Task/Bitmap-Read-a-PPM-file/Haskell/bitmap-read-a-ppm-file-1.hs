import Bitmap
import Bitmap.RGB
import Bitmap.Gray
import Bitmap.Netpbm

import Control.Monad
import Control.Monad.ST

main =
    (readNetpbm "original.ppm" :: IO (Image RealWorld RGB)) >>=
    stToIO . toGrayImage >>=
    writeNetpbm "new.pgm"
