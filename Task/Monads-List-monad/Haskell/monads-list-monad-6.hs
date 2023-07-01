pythagoreanTriples :: Integer -> [(Integer, Integer, Integer)]
pythagoreanTriples n = [(x,y,z) | x <- [1 .. n], y <- [x+1 .. n], z <- [y+1 .. n], x^2 + y^2 == z^2]
