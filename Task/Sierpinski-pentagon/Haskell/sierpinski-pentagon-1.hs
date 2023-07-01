import Graphics.Gloss

pentaflake :: Int -> Picture
pentaflake order = iterate transformation pentagon !! order
  where
    transformation = Scale s s . foldMap copy [0,72..288]
    copy a = Rotate a . Translate 0 x
    pentagon = Polygon [ (sin a, cos a) | a <- [0,2*pi/5..2*pi] ]
    x = 2*cos(pi/5)
    s = 1/(1+x)

main = display dc white (Color blue $ Scale 300 300 $ pentaflake 5)
  where dc = InWindow "Pentaflake" (400, 400) (0, 0)
