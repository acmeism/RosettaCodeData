import Graphics.HGL
import SuthHodgClip

targPts = [( 50,150), (200, 50), (350,150), (350,300), (250,300),
           (200,250), (150,350), (100,250), (100,200)] :: [(Float,Float)]
clipPts = [(100,100), (300,100), (300,300), (100,300)] :: [(Float,Float)]

toInts = map (\(a,b) -> (round a, round b))
complete xs = last xs : xs

drawSolid w c = drawInWindow w . withRGB c . polygon
drawLines w p = drawInWindow w . withPen p . polyline . toInts . complete

blue  = RGB 0x99 0x99 0xff
green = RGB 0x99 0xff 0x99
pink  = RGB 0xff 0x99 0x99
white = RGB 0xff 0xff 0xff

main = do
  let resPts = targPts `clipTo` clipPts
      sz = 400
      win = [(0,0), (sz,0), (sz,sz), (0,sz)]
  runWindow "Sutherland-Hodgman Polygon Clipping" (sz,sz) $ \w -> do
         print $ toInts resPts
         penB <- createPen Solid 3 blue
         penP <- createPen Solid 5 pink
         drawSolid w white win
         drawLines w penB targPts
         drawLines w penP clipPts
         drawSolid w green $ toInts resPts
         getKey w
