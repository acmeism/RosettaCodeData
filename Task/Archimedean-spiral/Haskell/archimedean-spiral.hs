#!/usr/bin/env stack
-- stack --resolver lts-7.0 --install-ghc runghc --package Rasterific --package JuicyPixels

import Codec.Picture( PixelRGBA8( .. ), writePng )
import Graphics.Rasterific
import Graphics.Rasterific.Texture
import Graphics.Rasterific.Transformations

archimedeanPoint a b t = V2 x y
  where r = a + b * t
        x = r * cos t
        y = r * sin t

main :: IO ()
main = do
  let white = PixelRGBA8 255 255 255 255
      drawColor = PixelRGBA8 0xFF 0x53 0x73 255
      size = 800
      points = map (archimedeanPoint 0 10) [0, 0.01 .. 60]
      hSize = fromIntegral size / 2
      img = renderDrawing size size white $
            withTransformation (translate $ V2 hSize hSize) $
            withTexture (uniformTexture drawColor) $
            stroke 4 JoinRound (CapRound, CapRound) $
            polyline points

  writePng "SpiralHaskell.png" img
