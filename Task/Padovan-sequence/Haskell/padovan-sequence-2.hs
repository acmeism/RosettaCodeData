import Data.List (unfoldr)

--------------------- PADOVAN NUMBERS --------------------

padovans :: [Integer]
padovans = unfoldr f (1, 1, 1)
  where
    f (a, b, c) = Just (a, (b, c, a + b))


padovanFloor :: [Integer]
padovanFloor = unfoldr f 0
  where
    f = Just . (((,) . g) <*> succ)

    g = floor . (0.5 +) . (/ s) . (p **) . fromInteger . pred
    p = 1.324717957244746025960908854
    s = 1.0453567932525329623


padovanLSystem :: [String]
padovanLSystem = unfoldr f "A"
  where
    f = Just . ((,) <*> concatMap rule)

    rule 'A' = "B"
    rule 'B' = "C"
    rule 'C' = "AB"


-------------------------- TESTS -------------------------

main :: IO ()
main =
  mapM_
    putStrLn
    [ "First 20 padovans:\n",
      show $ take 20 padovans,
      [],
      "The recurrence and floor based functions",
      "match over 64 terms:\n",
      show $ prefixesMatch padovans padovanFloor 64,
      [],
      "First 10 L-System strings:\n",
      show $ take 10 padovanLSystem,
      [],
      "The length of the first 32 strings produced",
      "is the Padovan sequence:\n",
      show $
        prefixesMatch
          padovans
          (fromIntegral . length <$> padovanLSystem)
          32
    ]

prefixesMatch :: Eq a => [a] -> [a] -> Int -> Bool
prefixesMatch xs ys n = and (zipWith (==) (take n xs) ys)
