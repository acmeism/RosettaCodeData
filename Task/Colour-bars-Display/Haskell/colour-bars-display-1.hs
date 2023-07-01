#!/usr/bin/env stack
-- stack --resolver lts-7.0 --install-ghc runghc --package vty -- -threaded

import Graphics.Vty

colorBars :: Int -> [(Int, Attr)] -> Image
colorBars h bars = horizCat $ map colorBar bars
  where colorBar (w, attr) = charFill attr ' ' w h

barWidths :: Int -> Int -> [Int]
barWidths nBars totalWidth = map barWidth [0..nBars-1]
  where fracWidth = fromIntegral totalWidth / fromIntegral nBars
        barWidth n =
          let n' = fromIntegral n :: Double
          in floor ((n' + 1) * fracWidth) - floor (n' * fracWidth)

barImage :: Int -> Int -> Image
barImage w h = colorBars h $ zip (barWidths nBars w) attrs
  where attrs = map color2attr colors
        nBars = length colors
        colors = [black, brightRed, brightGreen, brightMagenta, brightCyan, brightYellow, brightWhite]
        color2attr c = Attr Default Default (SetTo c)

main = do
    cfg <- standardIOConfig
    vty <- mkVty cfg
    let output = outputIface vty
    bounds <- displayBounds output
    let showBars (w,h) = do
          let img = barImage w h
              pic = picForImage img
          update vty pic
          e <- nextEvent vty
          case e of
            EvResize w' h' -> showBars (w',h')
            _ -> return ()
    showBars bounds
    shutdown vty
