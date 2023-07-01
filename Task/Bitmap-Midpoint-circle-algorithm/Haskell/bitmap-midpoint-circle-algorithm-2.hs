module CircleArrayExample where

import Circle

-- A surface is just a 2d array of characters for the purposes of this example
type Colour = Char
type Surface = Array (Int, Int) Colour

-- Returns a surface of the given width and height filled with the colour
blankSurface :: Int -> Int -> Colour -> Surface
blankSurface width height filler = listArray bounds (repeat filler)
  where
    bounds = ((0, 0), (width - 1, height - 1))

-- Generic plotting function. Plots points onto a surface with the given colour.
plotPoints :: Surface -> Colour -> [Point] -> Surface
plotPoints surface colour points = surface // zip points (repeat colour)

-- Draws a circle of the given colour on the surface given a center and radius
drawCircle :: Surface -> Colour -> Point -> Int -> Surface
drawCircle surface colour center radius
  = plotPoints surface colour (generateCirclePoints center radius)

-- Converts a surface to a string
showSurface image = unlines [[image ! (x, y) | x <- xRange] | y <- yRange]
  where
    ((xLow, yLow), (xHigh, yHigh)) = bounds image
    (xRange, yRange) = ([xLow..xHigh], [yLow..yHigh])

-- Converts a surface to a string and prints it
printSurface = putStrLn . showSurface
