import Graphics.Gloss

type Model = [Picture -> Picture]

fractal :: Int -> Model -> Picture -> Picture
fractal n model pict = pictures $ take n $ iterate (mconcat model) pict

main = animate (InWindow "Tree" (800, 800) (0, 0)) white $ tree1 . (* 60)
