type Line = (Point, Point)

type Point = (Float, Float)

intersection :: Line -> Line -> Either String Point
intersection ab pq =
  case determinant of
    0 -> Left "(Parallel lines – no intersection)"
    _ ->
      let [abD, pqD] = (\(a, b) -> diff ([fst, snd] <*> [a, b])) <$> [ab, pq]
          [ix, iy] =
            [\(ab, pq) -> diff [abD, ab, pqD, pq] / determinant] <*>
            [(abDX, pqDX), (abDY, pqDY)]
      in Right (ix, iy)
  where
    delta f x = f (fst x) - f (snd x)
    diff [a, b, c, d] = a * d - b * c
    [abDX, pqDX, abDY, pqDY] = [delta fst, delta snd] <*> [ab, pq]
    determinant = diff [abDX, abDY, pqDX, pqDY]

-- TEST ----------------------------------------------------------------
ab :: Line
ab = ((4.0, 0.0), (6.0, 10.0))

pq :: Line
pq = ((0.0, 3.0), (10.0, 7.0))

interSection :: Either String Point
interSection = intersection ab pq

main :: IO ()
main =
  putStrLn $
  case interSection of
    Left x -> x
    Right x -> show x
