newtype Mu a = Roll
  { unroll :: Mu a -> a }

fix :: (a -> a) -> a
fix = g <*> (Roll . g)
  where
    g = (. (>>= id) unroll)

- this version is not in tail call position...
-- fac :: Integer -> Integer
-- fac =
--   fix $ \f n -> if n <= 0 then 1 else n * f (n - 1)

-- this version builds a progression from tail call position and is more efficient...
fac :: Integer -> Integer
fac =
  (fix $ \f n i -> if i <= 0 then n else f (i * n) (i - 1)) 1

-- make fibs a function, else memory leak as
-- head of the list can never be released as per:
--   https://wiki.haskell.org/Memory_leak, type 1.1
-- overly complex version...
{--
fibs :: () -> [Integer]
fibs() =
  fix $
    (0 :) . (1 :) .
      (fix
        (\f (x:xs) (y:ys) ->
          case x + y of n -> n `seq` n : f xs ys) <*> tail)
--}

-- easier to read, simpler (faster) version...
fibs :: () -> [Integer]
fibs() = 0 : 1 : fix fibs_ 0 1
  where
    fibs_ fnc f s =
      case f + s of n -> n `seq` n : fnc s n

main :: IO ()
main =
  mapM_
    print
    [ map fac [1 .. 20]
    , take 20 $ fibs()
    ]
