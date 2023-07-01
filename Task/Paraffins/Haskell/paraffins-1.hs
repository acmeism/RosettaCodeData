-- polynomial utils
a `nmul` n = map (*n) a
a `ndiv` n = map (`div` n) a

instance (Integral a) => Num [a] where
  (+) = zipWith (+)
  negate = map negate
  a * b = foldr f undefined b where
    f x z = (a `nmul` x) + (0 : z)
  abs _ = undefined
  signum _ = undefined
  fromInteger n = fromInteger n : repeat 0

-- replace x in polynomial with x^n
repl a n = concatMap (: replicate (n-1) 0) a

-- S2: (a^2 + b)/2
cycleIndexS2 a b = (a*a + b)`ndiv` 2

-- S4: (a^4 + 6 a^2 b + 8 a c + 3 b^2 + 6 d) / 24
cycleIndexS4 a b c d =	((a ^ 4) +
			 (a ^ 2 * b) `nmul` 6 +
			 (a * c) `nmul` 8 +
			 (b ^ 2) `nmul` 3 +
			 d `nmul` 6) `ndiv` 24


a598 = x1
-- A000598: A(x) = 1 + (1/6)*x*(A(x)^3 + 3*A(x)*A(x^2) + 2*A(x^3))
x1 = 1 : ((x1^3) + ((x2*x1)`nmul` 3) + (x3`nmul`2)) `ndiv` 6
x2 = x1`repl`2
x3 = x1`repl`3
x4 = x1`repl`4

-- A000678 = x CycleIndex(S4, A000598(x))
a678 = 0 : cycleIndexS4 x1 x2 x3 x4

-- A000599 = CycleIndex(S2, A000598(x) - 1)
a599 = cycleIndexS2 (0 : tail x1) (0 : tail x2)

-- A000602 = A000678(x) - A000599(x) + A000599(x^2)
a602 = a678 - a599 + x2

main = mapM_ print $ take 200 $ zip [0 ..] a602
