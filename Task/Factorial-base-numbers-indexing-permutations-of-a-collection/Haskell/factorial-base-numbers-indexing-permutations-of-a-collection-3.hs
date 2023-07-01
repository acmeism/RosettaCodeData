task1 = do
  putStrLn "number\tfactoradic\tpermutation"
  mapM_ display [0..23]
  where
    display n =
      let f = toFact n
          p = permute "0123" (toPermutation f)
      in putStrLn $ show n ++ "\t" ++ show f ++ "\t\t(" ++ p ++ ")"

randomFactDigits seed = zipWith mod (random seed) [1..]
  where
    random = iterate $ \x -> (x * 1103515245 + 12345) `mod` (2^31-1)

task2 = do
  putStrLn "-- First example --"
  let n1 = toFact 61988771037597375208735783409763169805823569176280269403732950003152
  let crate1 = permute crate $ toPermutation n1
  putStrLn $ "Factoradic number:\n" ++ show n1
  putStrLn $ "Corresponding crate permutation:\n" ++ unwords crate1

  putStrLn "\n-- Second example --"
  let n2 = toFact 80576939285541005152259046665383499297948014296200417968998877609223
  let crate2 = permute crate $ toPermutation n2
  putStrLn $ "Factoradic number:\n" ++ show n2
  putStrLn $ "Corresponding crate permutation:\n" ++ unwords crate2

  putStrLn "\n-- Random example --"
  let n3 = Fact $ take 52 $ randomFactDigits 42
  let crate3 = permute crate $ toPermutation n3
  putStrLn $ "Factoradic number:\n" ++ show n3
  putStrLn $ "Decimal representation of n:\n" ++ show (fromFact n3)
  putStrLn $ "Corresponding crate permutation:\n" ++ unwords crate3
  where
  crate = words "A♠ K♠ Q♠ J♠ 10♠ 9♠ 8♠ 7♠ 6♠ 5♠ 4♠ 3♠ 2♠\
\                A♥ K♥ Q♥ J♥ 10♥ 9♥ 8♥ 7♥ 6♥ 5♥ 4♥ 3♥ 2♥\
\                A♦ K♦ Q♦ J♦ 10♦ 9♦ 8♦ 7♦ 6♦ 5♦ 4♦ 3♦ 2♦\
\                A♣ K♣ Q♣ J♣ 10♣ 9♣ 8♣ 7♣ 6♣ 5♣ 4♣ 3♣ 2♣"
