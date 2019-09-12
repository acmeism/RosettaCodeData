-- note that this version of fix uses function recursion in its own definition;
-- thus its use just means that the recursion has been "pulled" into the "fix" function,
-- instead of the function that uses it...
fix :: (a -> a) -> a
fix f = f (fix f) -- _not_ the {fix f = x where x = f x}

fac :: Integer -> Integer
fac =
  (fix $
    \f n i ->
      if i <= 0 then n
      else f (i * n) (i - 1)) 1

fib :: Integer -> Integer
fib =
  (fix $
    \fnc f s i ->
      if i <= 1 then f
      else case f + s of n -> n `seq` fnc s n (i - 1)) 0 1

{--
-- compute a lazy infinite list. This is
-- a Y-combinator version of: fibs() = 0:1:zipWith (+) fibs (tail fibs)
-- which is the same as the above version but easier to read...
fibs :: () -> [Integer]
fibs() = fix fibs_
  where
    zipP f (x:xs) (y:ys) =
      case x + y of n -> n `seq` n : f xs ys
    fibs_ a = 0 : 1 : fix zipP a (tail a)
--}

-- easier to read, simpler (faster) version...
fibs :: () -> [Integer]
fibs() = 0 : 1 : fix fibs_ 0 1
  where
    fibs_ fnc f s =
      case f + s of n -> n `seq` n : fnc s n

-- This code shows how the functions can be used:
main :: IO ()
main =
  mapM_
    print
    [ map fac [1 .. 20]
    , map fib [1 .. 20]
    , take 20 fibs()
    ]
