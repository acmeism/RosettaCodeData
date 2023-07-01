main =
    (readNetpbm "original.ppm" :: IO (Image RealWorld RGB)) >>=
    stToIO . (toRGBImage <=< toGrayImage) >>=
    writeNetpbm "new.ppm"
