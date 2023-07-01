pythagoreanTriples :: Integer -> [(Integer, Integer, Integer)]
pythagoreanTriples n =
  [1 .. n] >>= (\x ->
  [x+1 .. n] >>= (\y ->
  [y+1 .. n] >>= (\z ->
  if x^2 + y^2 == z^2 then return (x,y,z) else [])))

main = print $ pythagoreanTriples 25
